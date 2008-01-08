Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYAHXGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYAHXGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYAHXF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:05:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYAHXF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:05:57 -0500
Message-ID: <4783FFB6.3000909@redhat.com>
Date: Tue, 08 Jan 2008 17:56:54 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: =?UTF-8?B?R3VpbGxhdW1lIExhdXLDqHM=?= <guillaume-laures@neuf.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: I/O scheduler problem with an 8 SATA disks raid 5 under
 heavy load  ?
References: <F59D6EFA-C8EC-4678-97CE-8726260606EE@neuf.fr> <B4617BF6-ABC5-4B38-801C-142ED3882444@neuf.fr>
In-Reply-To: <B4617BF6-ABC5-4B38-801C-142ED3882444@neuf.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2008 03:22 PM, Guillaume Laurès wrote:
> However even with CFQ/NOOP I keep getting soft resets, only the sata_nv
> SATA ports, when under load. Any thoughs ?

Try the adma=0 option for the driver?
