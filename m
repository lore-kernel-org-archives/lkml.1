Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbXEQVOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbXEQVOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbXEQVOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:14:30 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:14622 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbXEQVO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tqds0av92DDrRo83T+URC3HLbGCSsgURRtmPZBh8DQjIstQzOD/1t5viPkZBFoKN4mr7Yxpt3wJiaK+uSM1TXAjgT5TzEwb2su72U2N802+3+Ho0JoPAckx1xxcDT//8FqjhrL5IQ7DHxmwDcK04xULlXLRbxUAXcM9sEvCqXIw=
Message-ID: <d120d5000705171414u55af4c03m6e6d2fbcf982e3ff@mail.gmail.com>
Date: Thu, 17 May 2007 17:14:26 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Cc: "Andrew Morton" <akpm@linux-foundation.org>, dedekind@infradead.org,
       linux-kernel@vger.kernel.org, "Christoph Hellwig" <hch@lst.de>
In-Reply-To: <20070517204234.GR4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron>
	 <20070517145653.GA968@lst.de> <1179414590.3642.69.camel@sauron>
	 <20070517102931.6bbbad1a.akpm@linux-foundation.org>
	 <20070517204234.GR4095@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, Al Viro <viro@ftp.linux.org.uk> wrote:
>
> Ahem...  So what does
>        x |= y;
> turns into with that approach?

Do we want to do such kind of operations on endian-annotated data? I'd
imagine you want to convert ot host-endianess first anyway.

-- 
Dmitry
