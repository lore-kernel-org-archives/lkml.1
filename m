Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab0BRQem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:34:42 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:20179
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758488Ab0BRQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:34:40 -0500
X-SpamScore: -26
X-BigFish: VPS-26(zz1432R98dN936eM9371Pzz1202hzzz32i87h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1Q0L-02-11D-02
X-M-MSG: 
Date: Thu, 18 Feb 2010 17:33:58 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] Nested SVM fixes (and Win7-64bit bringup)
Message-ID: <20100218163358.GT22141@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
 <4B7D4FBA.2030204@redhat.com>
 <9769FCB3-A4E4-4934-808C-A83ADCC72356@suse.de>
 <4B7D54AD.5080601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B7D54AD.5080601@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Feb 2010 16:33:59.0037 (UTC) FILETIME=[2BE4DAD0:01CAB0B8]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 04:54:37PM +0200, Avi Kivity wrote:
> On 02/18/2010 04:48 PM, Alexander Graf wrote:
> >On 18.02.2010, at 15:33, Avi Kivity wrote:
> >
> >>On 02/18/2010 01:38 PM, Joerg Roedel wrote:
> >>>Hi,
> >>>
> >>>here is a couple of fixes for the nested SVM implementation. I collected these
> >>>fixes mostly when trying to get Windows 7 64bit running as an L2 guest. Most
> >>>important fixes in this set make lazy fpu switching working with nested SVM and
> >>>the nested tpr handling fixes. Without the later fix the l1 guest freezes when
> >>>trying to run win7 as l2 guest. Please review and comment on these patches :-)
> >>>
> >>Overall looks good.  Would appreciate Alex looking over these as well.
> >The kmap thing is broken though, right?
> 
> Oh yes, but that's a search and replace, not something needing deep rework.

Great. I'll post again with fixes soon.

	Joerg


