Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbZFJP5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbZFJP5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760322AbZFJP5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:57:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55875 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760448AbZFJP5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:57:05 -0400
Date: Wed, 10 Jun 2009 16:58:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dirk Eibach <eibach@gdsys.de>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Dirk Eibach <eibach@gdsys.de>
Subject: Re: [PATCH] char: prevent opening unavailable ports in moxa.c
Message-ID: <20090610165822.5b947273@lxorguk.ukuu.org.uk>
In-Reply-To: <1244530656-32766-1-git-send-email-eibach@gdsys.de>
References: <1244530656-32766-1-git-send-email-eibach@gdsys.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Jun 2009 08:57:36 +0200
Dirk Eibach <eibach@gdsys.de> wrote:

> In moxa.c there are 32 minor numbers reserved for each device. The
> number of ports actually available per device is stored in
> moxa_board_conf->numPorts. This number is not considered in moxa_open().
> Opening a port that is not available results in a kernel oops.
> This patch adds a test to moxa_open() that prevents opening unavailable
> ports.
> 
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>


Applied - thanks

Alan
