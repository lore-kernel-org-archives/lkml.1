Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYLBMGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYLBMGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 07:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYLBMGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 07:06:09 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:56946 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYLBMGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 07:06:08 -0500
Date: Tue, 2 Dec 2008 13:06:06 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       xemul@openvz.org
Subject: Re: [RFC][PATCH 4/5] Protect cinit from fatal signals
Message-ID: <20081202120606.GD1132@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
	ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
	linux-kernel@vger.kernel.org, xemul@openvz.org
References: <20081126034242.GA23120@us.ibm.com> <20081126034634.GD23238@us.ibm.com> <20081127010753.GB13545@wavehammer.waldi.eu.org> <20081201202112.GC12493@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081201202112.GC12493@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 12:21:12PM -0800, Sukadev Bhattiprolu wrote:
> Container-inits are special in some ways and this change requires SIGKILL
> to terminate them.

No. They have are not special from the outside namespace.

Also it was discussed to use pid namespaces to preserve the local pid of
a process during snapshot/restore. This means that every process may get
the state of a container-init. And then it is not longer a wise idea to
make them behave different from the outside.

Bastian

-- 
I'm a soldier, not a diplomat.  I can only tell the truth.
		-- Kirk, "Errand of Mercy", stardate 3198.9
