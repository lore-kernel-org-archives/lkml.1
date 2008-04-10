Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYDJRle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYDJRle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbYDJRl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:41:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:52417 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbYDJRlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AF8DhIOXEnEzl7+Cv3oeoEpGtRkTxiQweLOIGi5Jbue08+C7ZMi1iJOoI5dvD4VI/aj/6sVjg6t7s4iu9/OC6xUlLFe8cLe1vSfimDeG56OtoGHyAxGrqYvxV9qWGPZWSZ5WgmMzdn4lVpsyX747G+vv7F4pEjLW71Cnfk2zDbo=
Message-ID: <e2e108260804101041k411b5fcfgc418f4be1bf7edba@mail.gmail.com>
Date: Thu, 10 Apr 2008 19:41:21 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jack Harvard" <jack.harvard@googlemail.com>
Subject: Re: gettimeofday() resolution in Linux?
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org
In-Reply-To: <a72f6a3c0804100859w4181d84ak1a63e7dec4d5b42f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
	 <20080410150424.GD2160@csclub.uwaterloo.ca>
	 <a72f6a3c0804100859w4181d84ak1a63e7dec4d5b42f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 5:59 PM, Jack Harvard
<jack.harvard@googlemail.com> wrote:
>  Here is an example of gettimeofday results, the time rolls back sometimes.

If the result of gettimeofday() rolls back, and there is no process on
your system that sets the time (like ntpd or hwclock --hctosys) then
this is a kernel bug. Which kernel version are you using, and which
kernel patches have been applied to that kernel ?

Bart.
