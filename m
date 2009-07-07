Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZGGUUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZGGUUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZGGUUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:20:34 -0400
Received: from mta.netezza.com ([12.148.248.132]:54032 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755200AbZGGUUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:20:33 -0400
Subject: Re: [2.6.27.25] assfail in xfs_attr_quiesce() during umount
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux XFS <linux-xfs@oss.sgi.com>, christoph hellwig <hch@ifradead.org>,
       david chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090707190643.GA32467@infradead.org>
References: <MAIL10OSN4RHlLx5ERz0002f238@mail1.netezza.com>
	 <20090707190643.GA32467@infradead.org>
Content-Type: text/plain
Organization: GNU's Not Unix!
Date: Tue, 07 Jul 2009 16:18:43 -0400
Message-Id: <1246997925.2984.1.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 20:18:51.0728 (UTC) FILETIME=[24CE9D00:01C9FF40]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 15:06 -0400, Christoph Hellwig wrote:
> It looks somehwat dangerous for me.  For now I would just comment
> out the assert or change it to a WARN_ON as in the newer kernels.

Hah!  :-).  OK, that works for me.

Thanks Christoph.

