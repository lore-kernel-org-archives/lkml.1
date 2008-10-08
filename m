Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYJHQjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYJHQjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 12:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYJHQjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 12:39:05 -0400
Received: from main.gmane.org ([80.91.229.2]:49454 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbYJHQjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 12:39:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Filesystem for block devices using flash storage?
Date: Wed, 08 Oct 2008 12:38:51 -0400
Message-ID: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 206-248-129-247.dsl.teksavvy.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
Cancel-Lock: sha1:1TPMpYS4yMwWAzu+7CEqPcEynsg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Google finds some people asking this same question, but I couldn't find
any answer to it: what filesystem is recommended to use on an flash
based disk that does not give access to the MTD layer (e.g. USB keys,
most SSDs, ...)?

Since they do their own wear-levelling, any filesystem should be "safe",
but I expect there is still a lot of variance in terms of performance,
wear, robustness, ...

Has anyone conducted serious experiemnts to try and find out what works
better?  Also, since it appears that such devices are here to stay,
would there be a need to design a new filesystem or to tune existing
filesystems for this particular kind of device?

Or is there some hope for SSDs to provide access to the MTD layer in the
not too distant future?


        Stefan

