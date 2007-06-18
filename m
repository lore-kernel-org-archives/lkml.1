Return-Path: <linux-kernel-owner+w=401wt.eu-S1764988AbXFRUho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764988AbXFRUho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762843AbXFRUhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:37:37 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53202 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762144AbXFRUhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:37:36 -0400
Subject: [RFC][Patch 0/3] integrity: Linux Integrity Module(LIM) and
	provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com, zohar@us.ibm.com
Content-Type: text/plain
Date: Mon, 18 Jun 2007 16:40:30 -0400
Message-Id: <1182199230.8577.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a request for comments for a subset of the original integrity
patches. By submitting this subset of the original patches, we hope to
simplify its review and ultimately ease its inclusion into the kernel.
For this reason, neither EVM nor SLIM are included in this patchset.
This patchset contains: Linux Integrity Module(LIM), Integrity
Measurement Architecture (IMA), and patches to the TPM driver. The LIM
patch defines 3 integrity API calls, 7 integrity hooks, placement of 
the hooks, and a dummy integrity service provider. There are very minor
changes from the previous release.  The IMA patch is now an independent
integrity service provider, which provides support for a subset of the
integrity API calls.

IBAC, a sample LSM module, which helps clarify the interaction between
LSM and LIM modules, will be posted separately to the LSM mailing list.
In addition, we are working on an SELinux integrity patch to take 
advantage of the integrity services, in a similar way to the IBAC
example.


Patch 1/3 integrity: Linux Integrity Module (LIM)
Patch 2/3 integrity: IMA as a stand alone integrity service provider
Patch 3/3 integrity: TPM internal kernel interface

Mimi Zohar
Dave Safford


