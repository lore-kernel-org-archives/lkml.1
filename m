Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbYESMgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbYESMgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760494AbYESMgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:36:13 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:28085 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760477AbYESMgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:36:12 -0400
To: Artem.Bityutskiy@nokia.com
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH take 2] UBIFS - new flash file system
From: Andi Kleen <andi@firstfloor.org>
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>
	<20080516104002.GA6962@infradead.org> <483164F2.1010908@nokia.com>
Date: Mon, 19 May 2008 14:36:10 +0200
In-Reply-To: <483164F2.1010908@nokia.com> (Artem Bityutskiy's message of "Mon, 19 May 2008 14:30:58 +0300")
Message-ID: <87prribhdx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 May 2008 12:29:08.0189 (UTC) FILETIME=[EF1758D0:01C8B9AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <Artem.Bityutskiy@nokia.com> writes:
>
> Could you please elaborate some more why UBIFS won't ever support nfs export?
> Does NFS export need correct readdir restarts?

Yes, because NFS is stateless. The seek offset has to be valid even over 
a reboot.

If you don't handle it you should probably better forbid nfs export
completely to avoid subtle problems.

-Andi

