Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYAZBso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYAZBso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 20:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbYAZBse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 20:48:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:39612 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356AbYAZBsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:48:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,253,1199692800"; 
   d="scan'208";a="330163727"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH 3/8] SVM: add module parameter to disable NestedPaging
Date: Fri, 25 Jan 2008 17:47:11 -0800
Message-ID: <2D848F959C03D945A84E9EDE7F7BFE4274021D@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1201294393-22613-4-git-send-email-joerg.roedel@amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH 3/8] SVM: add module parameter to disable NestedPaging
Thread-Index: AchflM8q4HjHWHeCRrOGoLdLnjgZvgAKA2WA
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-4-git-send-email-joerg.roedel@amd.com>
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Joerg Roedel" <joerg.roedel@amd.com>, "Avi Kivity" <avi@qumranet.com>,
       <kvm-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Jan 2008 01:47:12.0619 (UTC) FILETIME=[5EEE43B0:01C85FBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> To disable the use of the Nested Paging feature even if it is
available in
> hardware this patch adds a module parameter. Nested Paging can be
disabled by
> passing npt=off to the kvm_amd module.

I think it's better to use a (common) parameter to qemu. That way you
can control on/off for each VM.

Jun
---
Intel Open Source Technology Center
