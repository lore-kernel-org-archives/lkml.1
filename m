Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZE2XJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZE2XJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 19:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZE2XJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 19:09:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:23744 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZE2XJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 19:09:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,273,1241420400"; 
   d="scan'208";a="148542126"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: Andi Kleen <andi@firstfloor.org>,
       George Dunlap <george.dunlap@eu.citrix.com>
CC: "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 29 May 2009 16:09:19 -0700
Subject: RE: [Xen-devel] Re: Xen is a feature
Thread-Topic: [Xen-devel] Re: Xen is a feature
Thread-Index: AcngjC2kxLe7hGyOR8ylpz+T2aRv1QAF3gmQ
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A188156C9C@orsmsx505.amr.corp.intel.com>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
	<20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org>
	<20090528.210559.137121893.davem@davemloft.net>
	<4A1FCE8E.2060604@eu.citrix.com> <87tz33ep1b.fsf@basil.nowhere.org>
In-Reply-To: <87tz33ep1b.fsf@basil.nowhere.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/2009 11:34:40 AM, Andi Kleen wrote:
> George Dunlap <george.dunlap@eu.citrix.com> writes:
>
> cc list from hell trimmed.
>
> > allowing Linux to run as dom0 *is* improving Linux.  The lack of
> > dom0 support is at this moment making life more difficult for a huge
> > number of Linux users who use Xen, including Mozilla, Debian, and Amazon.
> > Adding dom0 support would make Linux even more useful to a wide
> > variety of people not using Xen at the moment.
>
> Perhaps one way to address this problem would be to make the Dom0
> interface less intrusive for the host OS?
>
> Maybe impression last time I looked was that there was huge potential
> of improvement in this area. For example the PAT issue recently
> discussed was completely unnecessary.  Or if you added a "VT/SVM only"
> Dom0 mode I'm sure the interface would be significantly cleaner too.
> If you can come up with a slim clean interface the chances for actual
> integration would be likely much higher.

I think we still need some (or all?) of additional dom0 PV ops even for HVM (Hardware-based VM) dom0. Hardware-based virtualization can significantly clean up the CPU-related PV ops (including some for local APIC), but they have nothing to do with dom0.

Some hooks in the host could be removed by reusing the HVM-specific code with modifications to the virtualization logic, but I think people need to tell which specific ones are intrusive, to be fair.

             .
Jun Nakajima | Intel Open Source Technology Center
