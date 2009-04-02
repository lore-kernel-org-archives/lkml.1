Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbZDBOmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbZDBOmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbZDBOmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:42:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43518 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759345AbZDBOmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:42:14 -0400
Message-ID: <49D4CEB1.9020001@redhat.com>
Date: Thu, 02 Apr 2009 17:41:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <87ab71monw.fsf@basil.nowhere.org> <49D35825.3050001@novell.com> <20090401132340.GT11935@one.firstfloor.org> <49D37805.1060301@novell.com> <20090401170103.GU11935@one.firstfloor.org> <49D3B64F.6070703@codemonkey.ws> <49D3D7EE.4080202@novell.com> <49D46089.5040204@redhat.com> <49D497A1.4090900@novell.com> <49D4A4EB.8020105@redhat.com> <49D4AE0C.3000604@novell.com> <49D4B2C0.5060906@redhat.com> <49D4B594.6080703@novell.com> <49D4B8B4.4020003@redhat.com> <49D4BF70.1060301@novell.com> <49D4C191.2070502@redhat.com> <49D4CAA7.3020004@novell.com> <49D4CC61.6010105@redhat.com>
In-Reply-To: <49D4CC61.6010105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> The alternative is to get a notification from the stack that the 
> packet is done processing.  Either an skb destructor in the kernel, or 
> my new API that everyone is not rushing out to implement.

btw, my new api is


   io_submit(..., nr, ...): submit nr packets
   io_getevents(): complete nr packets

-- 
error compiling committee.c: too many arguments to function

