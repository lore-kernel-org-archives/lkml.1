Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbXLTHHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbXLTHHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 02:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbXLTHHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 02:07:10 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39156 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753510AbXLTHHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 02:07:07 -0500
Date: Wed, 19 Dec 2007 23:07:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lee.shermerhorn@hp.com,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 01/20] convert anon_vma list lock a read/write lock
In-Reply-To: <20071218211548.681844332@redhat.com>
Message-ID: <Pine.LNX.4.64.0712192305540.13118@schroedinger.engr.sgi.com>
References: <20071218211539.250334036@redhat.com> <20071218211548.681844332@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Christoph Lameter <clameter@sgi.com>

Note that this is a nice improvement also to page migration.

Another solution may be to use a single linked list and RCU.

