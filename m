Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbXJLJZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbXJLJZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933011AbXJLJT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:19:58 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:45075 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933006AbXJLJT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:19:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ttUxoOPAMxmLJL4C8HjAIfOzC9L+OzftQYU0cTyLHoPDzVG1fV5q5V706CQ0yO5n2MvMxijnSC/hXWAFtr0thkd4Zf4PMKPf5SDKG0gyp5zNga77iBMNSVOFOu6eXHZTm/gp85au3VgFD/8mEGwyP4k/EjTLBzMIodwpjrz5LjY=  ;
X-YMail-OSG: A48_f6kVM1l3Gd819ZAqWQ67wPoBKL5EWAEpipAlP1MZOOd.fDRt8xoxSTO.yteoEdxZPSqiPA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/31] Remove iget() and read_inode() [try #4]
Date: Fri, 12 Oct 2007 02:48:05 +1000
User-Agent: KMail/1.9.5
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120248.05506.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2007 19:07, David Howells wrote:
> Hi Linus,
>
> Here's a set of patches that remove all calls to iget() and all
> read_inode() functions.  They should be removed for two reasons: firstly
> they don't lend themselves to good error handling, and secondly their
> presence is a temptation for code outside a filesystem to call iget() to
> access inodes within that filesystem.

Is there any particular reason not to push these through -mm?
