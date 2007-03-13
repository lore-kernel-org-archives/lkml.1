Return-Path: <linux-kernel-owner+w=401wt.eu-S1030739AbXCMPlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030739AbXCMPlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030745AbXCMPlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:41:15 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:7151 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030739AbXCMPlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:41:15 -0400
Message-ID: <45F6C93F.3080207@sw.ru>
Date: Tue, 13 Mar 2007 18:54:39 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Herbert Poetzl <herbert@13thfloor.at>
CC: Pavel Emelianov <xemul@sw.ru>, Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.osdl.org, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru> <20070306140036.4e85bd2f.akpm@linux-foundation.org> <45F3F581.9030503@sw.ru> <20070311045111.62d3e9f9.akpm@linux-foundation.org> <20070312010039.GC21861@MAIL.13thfloor.at> <45F51709.1010409@sw.ru> <20070312211111.GB21258@MAIL.13thfloor.at> <45F6BEFF.5000109@sw.ru> <20070313151154.GI8755@MAIL.13thfloor.at>
In-Reply-To: <20070313151154.GI8755@MAIL.13thfloor.at>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert,

>>Just curious why current vserver code kills arbitrary
>>task in container then?
> 
> 
> because it obviously lacks the finess of OpenVZ code :)
> 
> seriously, handling the OOM kills inside a container
> has never been a real world issue, as once you are
> really out of memory (and OOM starts killing) you 
> usually have lost the game anyways (i.e. a guest restart
> or similar is required to get your services up and
> running again) and OOM killer decisions are not perfect
> in mainline either, but, you've probably seen the 
> FIXME and TODO entries in the code showing that this
> is work in progress ...

I'm talking not about the finess of the code,
but rather about the lack of isolation,
i.e. one VE can affect others.

Kirill
