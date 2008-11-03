Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbYKCPOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbYKCPOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYKCPOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:14:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:25232 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbYKCPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:14:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:sender;
        b=WW4jqFM+kZYPsDBoi3APTV5AF7KO35N/DCdx5OUQQuLEtgfZwr2QSizsit5mAfb5OQ
         6sMFNMIIZRu1BluuxV1Jo5tz38nEXQdPkzVA1teQp4oZ+cUbFg52OcKKWXrpeX8GgRB/
         lFqDWD/nAhtf7hqet5ptgGJ8B4ljC0mk39M1A=
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc2: (mtd)block/partitions BUG with kobject reference count
References: <87ej1z4ep8.fsf@macbook.be.48ers.dk>
	<200810300027.19116.rjw@sisk.pl> <87abcnj810.fsf@macbook.be.48ers.dk>
	<ac3eb2510810301451x7dbf18edgd03c1433099ce5e4@mail.gmail.com>
	<ac3eb2510810301647k5e3dfecdjfa79f7e916fcdd20@mail.gmail.com>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Mon, 03 Nov 2008 16:14:00 +0100
In-Reply-To: <ac3eb2510810301647k5e3dfecdjfa79f7e916fcdd20@mail.gmail.com> (Kay Sievers's message of "Fri\, 31 Oct 2008 00\:47\:18 +0100")
Message-ID: <87d4hcc05j.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kay" == Kay Sievers <kay.sievers@vrfy.org> writes:

Hi,

 Kay> Looks like a bdi issue:
 Kay>   http://lkml.org/lkml/2008/10/30/519

 Kay> Peter, if I do this (whitespace mangled, just pasted in here), the
 Kay> error goes away for me. Can you try this?

Sorry for the slow response - Your patch
(http://lkml.org/lkml/2008/10/30/558) fixes the issue for me - Thanks!

-- 
Bye, Peter Korsgaard
