Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbXCPKZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbXCPKZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXCPKZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:25:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:32946 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbXCPKZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kLzcKePZoH7q+FZYJFrsvWJ+uP+RgZb9HBF+2Q7XDtbG5tyYybe+EvR/Ap6Qn/hLhg7ZWW+UCWdC6JFonuN4UDaroJ3CRERwfKbWK2/eivPSHedeL359PDGii4VWVM46OxOwbs1aTWWyWJAOiP3tkBE3z0dh8u5z/sREPDL9xOk=
Message-ID: <84144f020703160325h6e12069fl788cdb44114f817f@mail.gmail.com>
Date: Fri, 16 Mar 2007 12:25:45 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Chris Rankin" <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.2 - unable to handle kernel paging request - still accessing freed memory
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <30938.71164.qm@web52909.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <84144f020703160023l61ef82a4yd3d64d2f4fe9f1a0@mail.gmail.com>
	 <30938.71164.qm@web52909.mail.yahoo.com>
X-Google-Sender-Auth: fc835b7623bd4b3a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On 3/16/07, Chris Rankin <rankincj@yahoo.com> wrote:
> That would take ages - the only reason I kept on plugging away with winecfg last night
> was because I was fairly certain the kernel was going to "oops" eventually (which it did).
> But when exactly would I be able to declare a kernel "good" during a "git bisect"?

Yeah, if you can't reproduce at will, git bisect is very impractical.
Please try out the following patch to see if we catch a reference
counting underflow:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/detect-atomic-counter-underflows.patch
