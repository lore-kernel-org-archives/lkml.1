Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbYD0TSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbYD0TSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762747AbYD0TSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:18:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:2000 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762198AbYD0TSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eSBhxh478oqj4Jy9Gm2NYyIqtUpF8uWPBmDzTeCeGvwl7sj/xM7ACT1/i1fNVCcs14KCIbLqybc4zIbRZPqYreKIEq2C3+kQ6ArJBPGRNQCTRS9O/7OAjXRme6N+se1QIFg8+dM29yaU9g13fAy3L1/XZJjj+WvKsnsfn2GrUSE=
Subject: kvm: how big is type?
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 12:18:39 -0700
Message-Id: <1209323919.14173.73.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kvm/x86.c:3484:25: warning: cast truncates bits from constant value (100 becomes 0)
arch/x86/kvm/x86.c:3510:24: warning: cast truncates bits from constant value (100 becomes 0)

The problem:
		cseg_desc.type &= ~(1 << 8); //clear the B flag
		nseg_desc.type |= (1 << 8);

type is a 4-bit bitfield on x86....please look into this.

Harvey

