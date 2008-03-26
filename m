Return-Path: <linux-kernel-owner+w=401wt.eu-S1761745AbYCZSYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbYCZSYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761510AbYCZSYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:24:39 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:21651 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761501AbYCZSYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:organization:subject:date:user-agent:mime-version:content-disposition:to:cc:content-type:content-transfer-encoding:message-id;
        b=Bha55SwuD77CN7xolxMpRTFzl+UXZXZeKcH611SZP4NiS2cpfhgm9MqkE1nNu8W4FmkXNAEEZTdgc8ITQ/fhnNnG/z7C/KmXBxPXJrLp21hwKzOZN9Foho0mzsLz1uuRrp+NVg6JJHDVEs/5L0GhTaHqaO7xfrkV9CtOmFk/dKY=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
Subject: [RFC][-mm] [0/2] Basic stats for cgroups
Date: Wed, 26 Mar 2008 23:48:40 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Cc: containers@lists.osdl.org, dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       containers@lists.osdl.org, menage@google.com, a.p.zijlstra@chello.nl
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200803262348.40928.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is a first step towards implementing stats for cgroup 
subsystems. Only a few trivial stats for cpu and memory resource controller 
have been implemented for now. Please provide comments on the general 
direction and any suggestions on how you would like the cgroupstats framework 
to be implemented.

roadmap
--------
implement a generic statistics framework for cgroups,
unification with taskstats/netlink interface,
add more statistics 

-- 
regards,
balaji rao
