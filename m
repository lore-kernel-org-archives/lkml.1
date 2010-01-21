Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779Ab0AUUfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab0AUUfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 15:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519Ab0AUUfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 15:35:42 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:62655 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab0AUUfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 15:35:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aksXF+Wg1frqsXT1zHohj7uZ+7x4CeN8lyPFalbDdkA7Q+zlJdssBJEsxQD5rm4aC+
         pkYCJ98nevYF0ClkSQL0RaYhkNBDUEkpMW5rtFvZ4637hVVIcJkFWYf1hCDBtke4j5O8
         h127C3XQOEqYU8U8MzlSzADC7Hgm1nDuzkRCc=
Date: Thu, 21 Jan 2010 22:35:35 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel error : 'find /proc/ -type f | xargs -n 1 head -c 10
 >/dev/null'
Message-ID: <20100121203535.GA5133@x200>
References: <201001212017.00160.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201001212017.00160.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 08:16:59PM +0100, Toralf Förster wrote:
> I was inspired by http://article.gmane.org/gmane.linux.kernel/941115 .
> 
> Running the command (se subject) as a normal user at a 2.6.32.4 kernel
> gives this in /var/log/messages:
> 
> head: page allocation failure. order:9, mode:0xd0                                  
> Pid: 2324, comm: head Not tainted 2.6.32.4 #1                                      
> Call Trace:                                                                        
> [<c106e2cc>] ? __alloc_pages_nodemask+0x4bc/0x5a0                                  
> [<c108cf5a>] ? cache_alloc_refill+0x2ba/0x510                                      
> [<c108d299>] ? __kmalloc+0xe9/0xf0                                                 
> [<c10aa755>] ? seq_read+0x195/0x370                                                

Please, find out which file is causing this, if it's reproducible.
