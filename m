Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZCYL7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZCYL7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZCYL7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:59:06 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:49356 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZCYL7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:59:04 -0400
Date: Wed, 25 Mar 2009 12:58:45 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org, Stoyan Gaydarov <stoyboyker@gmail.com>,
       schwidefsky@de.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 05/13] [s390] changed ioctls to unlocked
Message-ID: <20090325125845.2923921b@osiris.boeblingen.de.ibm.com>
In-Reply-To: <1237929168-15341-6-git-send-email-stoyboyker@gmail.com>
References: <1237929168-15341-6-git-send-email-stoyboyker@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 16:12:40 -0500
stoyboyker@gmail.com wrote:

> From: Stoyan Gaydarov <stoyboyker@gmail.com>
> 
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  drivers/s390/char/tape_char.c  |   47 +++++++++++++++++++++++----------
>  drivers/s390/char/vmwatchdog.c |   57 ++++++++++++++++++++++++++--------------
>  2 files changed, 70 insertions(+), 34 deletions(-)

Please resend with the comments that Jonathan made for your other
patches: first define variables then lock_kernel() and also please use
gotos.

Thanks!
