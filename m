Return-Path: <linux-kernel-owner+w=401wt.eu-S934264AbXGXJgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbXGXJgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760384AbXGXJgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:36:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53906 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759602AbXGXJgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:36:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: which signal is sent to freeze process?
Date: Tue, 24 Jul 2007 11:44:33 +0200
User-Agent: KMail/1.9.5
Cc: nigel@suspend2.net, linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707232350.50208.rjw@sisk.pl> <A3258B497F1C1441AD36A2E8B45FD62858D7B7@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD62858D7B7@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241144.33954.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 July 2007 00:18, Agarwal, Lomesh wrote:
> The net effect would be same. Why would you choose one over other
> (do_sys_poll vs. do_poll)?

The last patch is simpler and it doesn't involve the try_to_freeze() thing.

> Can you point me to code where socket read returns in case of
> signal_pending? I need to try couple of things.

I need to find it myself, first. ;-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
