Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbYH0Np4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbYH0Np4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYH0Npr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:45:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbYH0Npr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:45:47 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/59] Introduce credentials
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Date: Wed, 27 Aug 2008 14:45:42 +0100
Message-ID: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



These patches build on patch 9e2b2dc4133f65272a6d3c5dcb2ce63f8a87cae9 (CRED:
Introduce credential access wrappers) to wrap most of the accesses to a task's
credentials, whether by the task itself or by another task.

Not all are wrapped: under certain circumstances it is preferable or necessary
to deal with some accesses in other ways.  These will be dealt with by patches
that aren't in this set but are in linux-next.

The wrappings are there to make the implementation of copy-on-write credentials
easier.

David
