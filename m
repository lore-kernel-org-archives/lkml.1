Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYAVTKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYAVTKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYAVTKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:10:30 -0500
Received: from [212.12.190.184] ([212.12.190.184]:54048 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752389AbYAVTKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:10:30 -0500
From: Al Boldi <a1426z@gawab.com>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: konqueror deadlocks on 2.6.22
Date: Tue, 22 Jan 2008 21:54:25 +0300
User-Agent: KMail/1.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Oliver Pinter (=?iso-8859-1?q?Pint=E9r?=
	=?iso-8859-1?q?=20Oliv=E9r?=) <oliver.pntr@gmail.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200801192114.41427.a1426z@gawab.com> <200801221623.42989.a1426z@gawab.com> <200801220925.50314.chris.mason@oracle.com>
In-Reply-To: <200801220925.50314.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801222154.25828.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> Running fsync in data=ordered means that all of the dirty blocks on the FS
> will get written before fsync returns.

Hm, that's strange, I expected this kind of behaviour from data=journal.

data=writeback should return immediatly, which seems it does, but 
data=ordered should only wait for metadata flush, it shouldn't wait for 
filedata flush.  Are you sure it waits for both?


Thanks!

--
Al

