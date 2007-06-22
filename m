Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbXFVJmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbXFVJmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXFVJmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:42:13 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:29294 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbXFVJmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:42:12 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Fri, 22 Jun 2007 11:35:59 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SVM: reliably detect if SVM was disabled by BIOS
Message-ID: <20070622093559.GA18450@amd.com>
References: <20070621175122.GE25896@amd.com>
 <467B96C8.1050500@qumranet.com>
MIME-Version: 1.0
In-Reply-To: <467B96C8.1050500@qumranet.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Jun 2007 09:36:11.0397 (UTC)
 FILETIME=[C4E58B50:01C7B4B0]
X-WSS-ID: 6A654784R0G949431-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 12:30:48PM +0300, Avi Kivity wrote:
> Joerg Roedel wrote:
> > From: Joerg Roedel <joerg.roedel@amd.com>
> >
> > This patch adds an implementation to the svm is_disabled function to
> > detect reliably if the BIOS disabled the SVM feature in the CPU. This
> > fixes the issues with kernel panics when loading the kvm-amd module on
> > machines where SVM is available but disabled.
> >
> >   
> 
> Applied; thanks.
> 
> Is this msr documented anywhere?  I assume it is implemented on all
> processors with svm?

Not in the public documentation yet. But it will be documented with one of
the next documentation updates. This MSR is implemented in all SVM
capable processors.

Regards,

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


