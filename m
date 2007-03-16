Return-Path: <linux-kernel-owner+w=401wt.eu-S965836AbXCPSoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965836AbXCPSoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965849AbXCPSoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:44:18 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:31869 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965836AbXCPSoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZoFdHzEruhEHe0dpqUO3DT99fDPNaPKJnE97SWWZqDnxPvDU5/kTqCtyKPXNylRQoK4LlCsxAy/KqTTgG4UF2aRxAEJMA+3gIlg9Pm1QpE9hq8HmbF8fCJrYztOOo1bvAapEyZIyPW5KilH/QFoqOaH7PI+mxIwC1ievjfmvBto=
Message-ID: <3d8471ca0703161144l5e32e25ax5bc771f2cb272c96@mail.gmail.com>
Date: Fri, 16 Mar 2007 19:44:14 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH] Add an offset in the cyc2ns computation to fix sched_clock jumps
Cc: "Andi Kleen" <ak@suse.de>, "john stultz" <johnstul@us.ibm.com>,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
In-Reply-To: <1174069846.3101.113.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
	 <1174069846.3101.113.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/16, Daniel Walker <dwalker@mvista.com>:
> Did you explain what the "werirdnes" was exactly? If not, could you?

I didn't track these weirdnesses in the scheduler code, but the symptom
is audio skipping and the mouse stops moving when the CPU becomes
busy and the ondemand governor increases the frequency. This lasts for
0.1~0.5 seconds and after that everything is fine.

Thank you all for the quick responses.

-- 
Guillaume
