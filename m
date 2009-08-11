Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZHKOwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZHKOwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZHKOwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:52:06 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:32127 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbZHKOwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:52:05 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Aug 2009 10:52:05 EDT
X-IronPort-AV: E=Sophos;i="4.43,360,1246831200"; 
   d="scan'208";a="31036556"
Date: Tue, 11 Aug 2009 16:41:58 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] braille_console: Read buffer overflow
Message-ID: <20090811144158.GZ5330@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Roel Kluin <roel.kluin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4A8181FA.2010009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A8181FA.2010009@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin, le Tue 11 Aug 2009 16:36:42 +0200, a écrit :
> If console_newline is true and console_cursor equals WIDTH

Err, that can never happen since when console_newline is true,
console_cursor is reset to 0, then incremented to 1.

Samuel
