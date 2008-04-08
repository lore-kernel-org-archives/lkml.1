Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbYDHQjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbYDHQjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYDHQjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:39:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:36666 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYDHQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=oIQaycgZM6457g1oK/On8Fg9wnNC5iI1prACHJW6P4vpPh66TuewIOrhitxUbHRG2NMUSJApVGmQvdI6Lq3CdnsPaVu0iCotR5UjJG/+Gxsvf3tcui1EurQAODHDk0k2WUWttQSp0tb5PvXXtdEAlgCHnnqb92wc1IWykOUj1Zg=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: "Paul Menage" <menage@google.com>
Subject: Re: [RFC][-mm] [0/2] Basic stats for cgroups V2
Date: Tue, 8 Apr 2008 22:02:30 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com, a.p.zijlstra@chello.nl,
       "Ingo Molnar" <mingo@elte.hu>
References: <200804052339.42474.balajirrao@gmail.com> <200804081919.14601.balajirrao@gmail.com> <6599ad830804080752w15882801oaa4fb4b661e7302a@mail.gmail.com>
In-Reply-To: <6599ad830804080752w15882801oaa4fb4b661e7302a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804082202.31150.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2008 08:22:16 pm Paul Menage wrote:
> On Tue, Apr 8, 2008 at 6:49 AM, Balaji Rao <balajirrao@gmail.com> wrote:
> >
> >  We are also looking at a generic framework in cgroups that would delegate 
the
> >  job of handling statistics to the cgroup framework itself. This would 
avoid
> >  code duplication across various controllers.
> 
> Yes, avoiding code duplication is good.
> 
> On thing - when you say "statistics" do you mean all statistics (i.e.
> all values that can be read from control files) or specifically
> arrays/maps of values in specific control files? I'm using it to mean
> the former, but you appear to be mostly referring to stats maps such
> as "memory.stat" or "cpu.stat".

Sorry for the confusion. You're right. I'm speaking about the "cpu.stat" 
and "memory.stat" idea. What we want is, a layer above the generic file 
presentation layer, that would collect and manage the statistics the 
controllers would provide.

-- 
regards,
Balaji Rao
Dept. of Mechanical Engineering,
National Institute of Technology Karnataka, India
