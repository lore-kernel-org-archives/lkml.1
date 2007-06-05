Return-Path: <linux-kernel-owner+w=401wt.eu-S1764171AbXFENhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764171AbXFENhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760758AbXFENhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:37:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:59259 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760797AbXFENhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=i0+4oyCMM0VPftHJQH/29b7UrNzxLO01hGqBp77QE14AAyVfCXoctBElwYWfMJBiyuXLKILsTi6JX8kWhUwJfugq3VJ4jd6OaHutykDGI9EKb3381nmhmk6Sq1RYoHFJ9J2NW0B3Zj/LsVjUgsoaTUdVbwrTLTIQvscPT6eFAs0=
Date: Tue, 5 Jun 2007 09:37:29 -0400
To: Tom Moore <tmoore@spatial.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 4Gb ram not showing up
Message-ID: <20070605133729.GA20615@nineveh.local>
Mail-Followup-To: Tom Moore <tmoore@spatial.ca>,
	linux-kernel@vger.kernel.org
References: <46642C60.209@spatial.ca> <20070604191052.GD10008@csclub.uwaterloo.ca> <46646BF2.9020705@spatial.ca> <20070604222840.GC10208@animx.eu.org> <46656120.9020103@spatial.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46656120.9020103@spatial.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 09:12:00AM -0400, Tom Moore wrote:

> Ok, so it appears that this one is wrong also.  If someone could explain
> the rules that apply, I would be happy to prepare a patch to the Kconfig
> script.  I don't consider myself to be completely stupid, and if the
> help text was a bit more clear I wouldn't be asking these questions.
> I'm sure that other pilgrims will follow along later with the same
> questions.

   If you do create such a patch, please also state that HIGHMEM64G is
necessary for support of the NX bit (on those processors that support
it).

   ISTR that a similar issue exists in the NOHIGHMEM case, where some
150MB or so of RAM would be unusable in a 1GB machine with NOHIGHMEM.
I could be mis-remembering, that, though.

--
Joseph Fannin
jfannin@gmail.com || jhf@columbus.rr.com

