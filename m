Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbZJHQYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbZJHQYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932512AbZJHQYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:24:05 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:46999
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932369AbZJHQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:24:04 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zba6lz1432R98dN936eM9371Pzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KR7EUL-03-7BA-02
X-M-MSG: 
Date: Thu, 8 Oct 2009 18:23:08 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] KVM: SVM: Add tracepoint for invlpga instruction
Message-ID: <20091008162308.GH14073@amd.com>
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
 <1254996199-17667-8-git-send-email-joerg.roedel@amd.com>
 <4ACE0CF3.7090101@redhat.com>
 <20091008161815.GF14073@amd.com>
 <4ACE1175.1010706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4ACE1175.1010706@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Oct 2009 16:23:08.0778 (UTC) FILETIME=[9F5E74A0:01CA4833]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 06:21:09PM +0200, Avi Kivity wrote:
> On 10/08/2009 06:18 PM, Joerg Roedel wrote:
> >
> >>Also, kvm tracepoints don't use '=' in TP_printk(), please keep it
> >>consistent.
> >I had it with "key: value" formating first but decided to do it this way
> >because it simplifies automatic parsing of these trace events. With this
> >format a script can first split by spaces and get the key-value pairs by
> >splitting on the equal sign. This is also more robust against changes in
> >the format.
> >
> 
> Automatic parsing should use the binary transport (which simply has
> the TP_struct things).

Ok, in this case I'll change it.

	Joerg


