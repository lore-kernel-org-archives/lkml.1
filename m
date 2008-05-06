Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbYEFN4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbYEFN4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYEFN4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:56:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40037 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbYEFN4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:56:15 -0400
Date: Tue, 6 May 2008 06:56:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Timur Alperovich" <timur.alperovich@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: exported version of page_is_ram?
Message-ID: <20080506065604.0e4c2183@infradead.org>
In-Reply-To: <52950c3f0805051413r7d41c4f0tcdc21dc7938d05e8@mail.gmail.com>
References: <52950c3f0805051058t5d3447c2r3ae8e77cf0166b00@mail.gmail.com>
	<20080505125035.719feaa5@infradead.org>
	<52950c3f0805051413r7d41c4f0tcdc21dc7938d05e8@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 17:13:46 -0400
"Timur Alperovich" <timur.alperovich@gmail.com> wrote:

> I put the whole driver on pastebin http://pastebin.com/m24c50118
> For now I tried to use the code for page_is_ram in there, only to
> realize that e820 struct is also not exported. Is there a way to do
> this with the existing code in the kernel, since I'd like the code to
> run on older 2.6 kernels as well?

to be honest, the real solution would be to make an "for each memory
page" iterator in the main kernel... 
working on older kernels isn't going to fly though that way;(
