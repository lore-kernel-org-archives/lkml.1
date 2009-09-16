Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbZIPOT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbZIPOT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZIPOT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:19:27 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:14689
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751418AbZIPOT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:19:26 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432R98dN936eM9371Pzz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQ2IFL-03-6TB-01
Date: Wed, 16 Sep 2009 16:18:58 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/5] Another set of Nested SVM fixes and cleanups
Message-ID: <20090916141858.GH8480@amd.com>
References: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
 <4AB0F013.8050608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4AB0F013.8050608@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Sep 2009 14:18:58.0893 (UTC) FILETIME=[A1CDB7D0:01CA36D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 05:02:59PM +0300, Avi Kivity wrote:
> On 09/16/2009 04:24 PM, Joerg Roedel wrote:
> >Hi,
> >
> >this series of patches contain another set of cleanups and an important fix to
> >the Nested SVM code. These patches make the TSC handling code for SVM aware of
> >a nested guest. This fixes the TSC running backwards on guest and nested guest.
> >The backwards running TSC resulted in stalled guests when kvm-clock was
> >enabled. Please consider to apply.
> >
> 
> Looks good.  3, 4 needed for 2.6.32-rc as well, yes?

Yes, would be good since these two are real bugfixes. Probably also
relevant for -stable.

	Joerg


