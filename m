Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbZFNXM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbZFNXM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbZFNXMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:12:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52230 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752729AbZFNXMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:12:51 -0400
Date: Mon, 15 Jun 2009 00:14:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeni Golov <sargentd@die-welt.net>
Cc: linux-kernel@vger.kernel.org, Evgeni Golov <sargentd@die-welt.net>
Subject: Re: [PATCH 2/2] use the TASK_COMM_LEN macro instead of
 sizeof(tsk->comm)
Message-ID: <20090615001410.24327266@lxorguk.ukuu.org.uk>
In-Reply-To: <1244998668-27078-2-git-send-email-sargentd@die-welt.net>
References: <1244998668-27078-1-git-send-email-sargentd@die-welt.net>
	<1244998668-27078-2-git-send-email-sargentd@die-welt.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009 18:57:48 +0200
Evgeni Golov <sargentd@die-welt.net> wrote:

> sizeof(tsk->comm) == TASK_COMM_LEN, always, so why not use it?

Because if the size ever changes the existing code will remain correct
and your changes will become a dangerous buffer overrun ?

Alan
