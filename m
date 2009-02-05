Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbZBESmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbZBESmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZBESmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:42:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35670 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZBESmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:42:36 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       akataria@vmware.com
Subject: [PATCH 0/2] expose hypervisor information on cpuid
Date: Thu,  5 Feb 2009 13:42:19 -0500
Message-Id: <1233859341-10419-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This discussion happened some days ago in kvm list.
We believe it's useful to advertise hypervisor information
somewhere. /proc/cpuinfo appears as one good candidate.

This patch shows this information for vmware, kvm, and the
string "none", otherwise. (someone would have to do it for xen,
and possibly others, if this patch is to be accepted).


