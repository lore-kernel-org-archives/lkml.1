Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYLBKPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYLBKPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYLBKPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:15:04 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:49649 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbYLBKPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:15:01 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@redhat.com>
Subject: [PATCH 0/2] module_refcounting and anonymous inodes
Date: Tue, 2 Dec 2008 11:14:59 +0100
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200812021114.59050.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Avi,

here is the latest respin of my fixes for the kvm module unload problem:

[PATCH 1/2] anon_inodes: use fops->owner for module refcount
[PATCH 2/2] kvm: set owner of cpu and vm file operations

Both patches fix module reference counting problems and only matter for module
unload - nothing critical. 

Tested on s390 and x86_32.


Christian
