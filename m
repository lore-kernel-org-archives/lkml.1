Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbZJ0Xwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbZJ0Xwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 19:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbZJ0Xwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 19:52:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:47403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbZJ0Xwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 19:52:35 -0400
Date: Tue, 27 Oct 2009 16:53:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: scheduling while atomic acpi_idle_enter_bm
Message-ID: <20091027165345.3237d3df@infradead.org>
In-Reply-To: <43e72e890910271640n7fafc8edpc14143fcfca7df60@mail.gmail.com>
References: <43e72e890910271640n7fafc8edpc14143fcfca7df60@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 16:40:03 -0700
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> I get this when modprobing some module I am working on. I figured it
> was the module's fault but the EIP points to something else so I am
> not sure. I get the following repeating about 4 times on 2.6.32-rc5:


you can get this if your own code leaves interrupts disabled in a
kernel thread and then lets the cpu go idle...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
