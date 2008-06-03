Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbYFCGCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbYFCGCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYFCGCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:02:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:65179 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYFCGCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YevieJ57jU6vgD7HaHs/2l3sBgftA1A8FMDNNYqfK/O81dYFBP/rSYRYZrGC9a610kQyjIWeIkttd+qBCVueIMK4cLTDxRsyu576O/85ItwsQF6cU9lugziz7ajJtc8bAqpUWZWm6Bb6JVqT7zgckfFu/mY7TL/i8xduO4OuM+I=
Message-ID: <3877989d0806022302w50f36d28m33c5039d83e08228@mail.gmail.com>
Date: Tue, 3 Jun 2008 14:02:09 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <3877989d0805280214y645c7e0ex91a95f1fe47a6abf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com>
	 <20080526001527.81E1126FA9E@magilla.localdomain>
	 <3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com>
	 <3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com>
	 <20080527040454.053C526FA9E@magilla.localdomain>
	 <3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com>
	 <20080527061209.9A24426FAA6@magilla.localdomain>
	 <3877989d0805270148h1b9e7972w880e380c2c4c9b09@mail.gmail.com>
	 <3877989d0805280214y645c7e0ex91a95f1fe47a6abf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm trying upstream kdump to get more detailed data for help analysis
> the scenario..
Upstream kdump doesn't work! don't know what cause the regression,
possibly kexec-tools...
Need investigation here!
