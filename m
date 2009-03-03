Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZCDAcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZCDAcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZCDAcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:32:32 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47164 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbZCDAcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:32:31 -0500
Subject: Re: [PATCH 2/3] c/r: Add CR_COPY() macro (v3)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Dan Smith <danms@us.ibm.com>
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1236095764-19325-3-git-send-email-danms@us.ibm.com>
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
	 <1236095764-19325-3-git-send-email-danms@us.ibm.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 08:22:12 -0800
Message-Id: <1236097332.22399.8.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 10:56 -0500, Dan Smith wrote:
> As suggested by Dave[1], this provides us a way to make the copy-in and
> copy-out processes symmetric.  CR_COPY_ARRAY() provides us a way to do
> the same thing but for arrays.  It's not critical, but it helps us unify
> the checkpoint and restart paths for some things.

Did you convince Nathan that this ends up being a good idea?

-- Dave

