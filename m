Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbYAYIsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbYAYIsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762005AbYAYIix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:38:53 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:36069 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758180AbYAYIiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:38:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EKjyRm60mNwNtRrhLxYGh3snEm1Dv5/4K4nvN7mY+EVodcsNgU2Xp1qwOSNqbDeYKcXfMWBG9u7JpJut6FCl1thiypRPIQbshdzaj5PYH9W3Xbo5wz/lYdmclR8EHTna2AhsGmzijo8Jl1nMoWKWMVUd8frwc0U7v3OoZs4gz9M=  ;
X-YMail-OSG: I7.dZNoVM1l8GqNZaGQudC7f7buPEIeTIANe26dqDAG7MJCYcow9_BLYWP2tENDi.2F29bhL_A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
Date: Fri, 25 Jan 2008 19:38:38 +1100
User-Agent: KMail/1.9.5
Cc: "Keir Fraser" <Keir.Fraser@cl.cam.ac.uk>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Matt Mackall" <mpm@selenic.com>, "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <47992CB2.8050606@goop.org> <C3BF420A.12CFE%Keir.Fraser@cl.cam.ac.uk> <4799A8A6.76E4.0078.0@novell.com>
In-Reply-To: <4799A8A6.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251938.39231.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 19:15, Jan Beulich wrote:
> Actually, another thought: permitting (and handling) spurious faults for
> kernel mappings conflicts with NMI handling, i.e. great care would be
> needed to ensure the NMI path cannot touch any such mapping. So
> even the present Xen/Linux Dom0 implementation may have some
> (perhaps unlikely) problems here, and it would get worse if we added
> e.g. a virtual watchdog NMI (something I am considering, which would
> then extend the problem to DomU-s).

Can you explain how they conflict?

Thanks,
Nick
