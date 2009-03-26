Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbZCZQUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbZCZQUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZCZQTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:19:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48894 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbZCZQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:19:51 -0400
Date: Thu, 26 Mar 2009 16:19:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>, linux-kernel@vger.kernel.org
Subject: Re: Are path-based LSM hooks called from the wrong places?
Message-ID: <20090326161945.GU28946@ZenIV.linux.org.uk>
References: <20090326155357.GS28946@ZenIV.linux.org.uk> <13750.1237997653@redhat.com> <18658.1238084066@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18658.1238084066@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 04:14:26PM +0000, David Howells wrote:

> As I said, what I don't want to have to do is attempt to regenerate the full
> pathname, especially if the pathname isn't accessible from within the current
> process's chroot or namespace.

... and if it's not accessible from said process' namespace, pathname-based
checks are going to produce really bizarre results.

IOW, I'd say that such checks simply don't apply in case of fscache.
