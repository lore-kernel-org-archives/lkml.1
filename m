Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbYESRYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbYESRYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYESRYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:24:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:17302 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYESRYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Mzvy1qEPL4ITYYrh7ktDD1+MmcAyMuJs5ysEFPKX4yWawhGjlikez0TaXHjCWTlygPwZw227evRhL9bbNOsjehSI2/GAJCpyxtBeMItSkNoTpSSVZD0KTTc5o7nscb5T2zkHuPjGLAmYvVA0CwKkEwD/CkvoVkJLR0cCA1wVNxY=
Date: Tue, 20 May 2008 01:24:04 +0800
From: Jianjun Kong <kongjianjun@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] delete unuseful note
Message-ID: <20080519172404.GA11030@ubuntu>
References: <1211214730811-git-send-email-kongjianjun@gmail.com> <20080519165006.GA17605@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080519165006.GA17605@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 05:50:07PM +0100, Russell King wrote:
> On Tue, May 20, 2008 at 12:32:10AM +0800, Jianjun Kong wrote:
> > Change of initials.
> > "rmk" -> "RMK"
> > "linus" -> "Linus".
> > 
> > ---
> >  drivers/serial/mux.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/serial/mux.c b/drivers/serial/mux.c
> > index e940317..b259b07 100644
> > --- a/drivers/serial/mux.c
> > +++ b/drivers/serial/mux.c
> > @@ -356,7 +356,7 @@ static int mux_request_port(struct uart_port *port)
> >   * Perform any autoconfiguration steps for the port.  This function is
> >   * called if the UPF_BOOT_AUTOCONF flag is specified for the port.
> 
> The part of the comment below should be deleted.
> 
> >   * [Note: This is required for now because of a bug in the Serial core.
> > - *  rmk has already submitted a patch to linus, should be available for
> > + *  RMK has already submitted a patch to Linus, should be available for
> >   *  2.5.47.]
> >   */
> >  static void mux_config_port(struct uart_port *port, int type)

Another new one.
Delete the unuseful note.

Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>
---
 drivers/serial/mux.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/mux.c b/drivers/serial/mux.c
index e940317..551c469 100644
--- a/drivers/serial/mux.c
+++ b/drivers/serial/mux.c
@@ -355,9 +355,6 @@ static int mux_request_port(struct uart_port *port)
  *
  * Perform any autoconfiguration steps for the port.  This function is
  * called if the UPF_BOOT_AUTOCONF flag is specified for the port.
- * [Note: This is required for now because of a bug in the Serial core.
- *  rmk has already submitted a patch to linus, should be available for
- *  2.5.47.]
  */
 static void mux_config_port(struct uart_port *port, int type)
 {
-- 
1.5.2.5

