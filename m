Return-Path: <linux-kernel-owner+w=401wt.eu-S1762174AbZANLoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762174AbZANLoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761923AbZANLm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:42:57 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4160 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762202AbZANLm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:42:56 -0500
Date: Wed, 14 Jan 2009 12:42:47 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Message-ID: <20090114114247.GB23674@vanheusden.com>
References: <1231774622.4371.96.camel@laptop> <20090114114059.GA23674@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090114114059.GA23674@vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu Jan 15 09:10:29 CET 2009
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The key criteria for the busy wait is that the lock owner has to be running on
> > a (different) cpu. The idea is that as long as the owner is running, there is a
> > fair chance it'll release the lock soon, and thus we'll be better off spinning
> > instead of blocking/scheduling.
> 
> Won't this make Linux less "green"? (-> use more power since busy loops
> use more power than idle loops) If so, maybe it should be make
> configurable somewhere?

Oh darn, it *is* configurable at run-time.
Sorry for the noise.


Folkert van Heusden

-- 
Multitail est un outil permettant la visualisation de fichiers de
journalisation et/ou le suivi de l'exécution de commandes. Filtrage,
mise en couleur de mot-clé, fusions, visualisation de différences
(diff-view), etc.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
