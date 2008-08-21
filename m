Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbYHUQZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbYHUQZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYHUQZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:25:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:64982 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYHUQZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jv0ehkWGxMJqhEq0BE57RsM9WUWKsOWgI2UIN0xHzwLVjtq8AGcPMCmZxrX98fV4JC
         2dXbswrl/yL7tIZVmTjcxXcWqVVQ/IfxB4OhEcuD9kZRLN7tDUO3bsoeVQdqyhk17dCi
         55EFYg5Y7PQBYgqc5TiGTUUga6r/DwxaAOCUY=
Message-ID: <86802c440808210925g401d62e4td84a43c223571327@mail.gmail.com>
Date: Thu, 21 Aug 2008 09:25:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: patch "x86: MOVE PCI IO ECS code to x86/pci" breaks CPU hotplug
Cc: "Jan Beulich" <jbeulich@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080821132952.GD13011@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD82D5.76E4.0078.0@novell.com>
	 <20080821132952.GD13011@erda.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 6:29 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 21.08.08 13:59:33, Jan Beulich wrote:
>> Even worse - this would even try to access the MSR on non-AMD CPUs
>> (currently probably prevented just by the fact that only AMD ones use
>> family values of 0x10 or higher).
>
> Ups, really worse. Code was AMD specific before and became
> generic. Will fix this.
>

it seems you didn't address the concern about hotplug as you promised

http://lkml.org/lkml/2008/6/13/151

YH
