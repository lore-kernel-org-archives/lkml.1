Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbYAZSXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbYAZSXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 13:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYAZSXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 13:23:37 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:60583
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512AbYAZSX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 13:23:28 -0500
Message-ID: <479B7A8F.8070308@qumranet.com>
Date: Sat, 26 Jan 2008 20:23:11 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Nakajima, Jun" <jun.nakajima@intel.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] SVM: add module parameter to disable
 NestedPaging
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>	<1201294393-22613-4-git-send-email-joerg.roedel@amd.com>	<2D848F959C03D945A84E9EDE7F7BFE4274021D@orsmsx424.amr.corp.intel.com> <20080126072556.GB21476@8bytes.org>
In-Reply-To: <20080126072556.GB21476@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Generally I see no problem with it. But at least for NPT I don't see a
> reason why someone should want to disable it on a VM basis (as far as it
> works stable). Avi, what do you think?
>   

Unless there is a real-life workload that benefits from npt=0, I see no 
reason to have per-vm npt control.  The module parameter is helpful, for 
to isolate npt problems and for development, but I don't see a need for 
users to fiddle with it.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

