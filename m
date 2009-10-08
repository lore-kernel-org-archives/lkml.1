Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZJHQTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZJHQTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbZJHQTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:19:45 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:13223 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbZJHQTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:19:43 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zba6lz1432R98dN936eM9371Pzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KR7EMH-03-757-02
X-M-MSG: 
Date: Thu, 8 Oct 2009 18:18:15 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] KVM: SVM: Add tracepoint for invlpga instruction
Message-ID: <20091008161815.GF14073@amd.com>
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
 <1254996199-17667-8-git-send-email-joerg.roedel@amd.com>
 <4ACE0CF3.7090101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4ACE0CF3.7090101@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Oct 2009 16:18:16.0163 (UTC) FILETIME=[F0F4F330:01CA4832]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 06:01:55PM +0200, Avi Kivity wrote:
> On 10/08/2009 12:03 PM, Joerg Roedel wrote:
> >This patch adds a tracepoint for the event that the guest
> >executed the INVLPGA instruction.
> >+
> >+	TP_printk("rip=0x%016llx asid=%d adress=0x%016llx\n",
> >+		  __entry->rip, __entry->asid, __entry->address)
> >+);
> 
> s/adress/address/.
> 
> Also, kvm tracepoints don't use '=' in TP_printk(), please keep it
> consistent.

I had it with "key: value" formating first but decided to do it this way
because it simplifies automatic parsing of these trace events. With this
format a script can first split by spaces and get the key-value pairs by
splitting on the equal sign. This is also more robust against changes in
the format.

	Joerg


