Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZCEWyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZCEWyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbZCEWyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:54:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58765 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754234AbZCEWyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:54:09 -0500
Date: Thu, 5 Mar 2009 17:54:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Walker <dwalker@fifo99.com>
cc: Yinghai Lu <yinghai@kernel.org>, <mingo@redhat.com>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>, <randy.dunlap@oracle.com>,
       <ebiederm@xmission.com>, <akpm@linux-foundation.org>, <gregkh@suse.de>,
       <tglx@linutronix.de>, <sarah.a.sharp@intel.com>, <mingo@elte.hu>,
       <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
In-Reply-To: <1236292823.5937.84.camel@desktop>
Message-ID: <Pine.LNX.4.44L0.0903051751330.2174-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009, Daniel Walker wrote:

> Fix up some typos, and make the requirements section slightly cleaner.
> 
> Signed-Off-By: Daniel Walker dwalker@fifo99.com
> 
> diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
> index 607b1a0..5b51aef 100644
> --- a/Documentation/x86/earlyprintk.txt
> +++ b/Documentation/x86/earlyprintk.txt
> @@ -9,7 +9,9 @@ and two USB cables, connected like this:
>  
>  1. There are three specific hardware requirements:
>  
> - a.) Host/target system needs to have USB debug port capability.
> + a.) You will need two USB ports. One on the client/console system and one one the target system.

s/one one/one on/

You might also try harder to observe the 80-column rule.

> + 
> + b.) The client/console and target USB ports must have the debug port capability.
>  
>   You can check this capability by looking at a 'Debug port' bit in
>   the lspci -vvv output:
> @@ -35,15 +37,13 @@ and two USB cables, connected like this:
>  ( If your system does not list a debug port capability then you probably
>    wont be able to use the USB debug key. )
>  
> - b.) You also need a Netchip USB debug cable/key:
> + c.) You also need a Netchip USB debug cable/key:
>  
>          http://www.plxtech.com/products/NET2000/NET20DC/default.asp
>  
>       This is a small blue plastic connector with two USB connections,
>       it draws power from its USB connections.

No.  It draws power from one of its USB connections (the one on the 
right side when you're looking at the face with the PLX logo).

Alan Stern

