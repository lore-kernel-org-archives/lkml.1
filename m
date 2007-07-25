Return-Path: <linux-kernel-owner+w=401wt.eu-S934165AbXGYRNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbXGYRNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933266AbXGYRMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:12:53 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:52937 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447AbXGYRMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:12:52 -0400
Message-ID: <46A78488.4090907@de.ibm.com>
Date: Wed, 25 Jul 2007 19:12:40 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com> <46A4829C.9080104@qumranet.com> <20070723200659.GA13508@c2.user-mode-linux.org> <46A58CAD.7070807@qumranet.com> <20070725161544.GA7747@c2.user-mode-linux.org>
In-Reply-To: <20070725161544.GA7747@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> I want it to be identity-mapped, which a single address space would
> guarantee.  For things which change mappings, like vmalloc, I need to
> be in the same address space as the guest.
That'll also be mandatory required by hw when porting this to s390.
