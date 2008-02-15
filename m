Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbYBOTkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbYBOTkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYBOTkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:40:45 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:35587 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbYBOTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:40:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bRHM/zGrVzrU8hzoC6Pg1ZJpK2JvxCrFn42iHnMErMz/Xu8+QfY7WYqsSM8heEKmLRzSrfXHMucfpIDWsGuaC6NTOMc9uCeamIhg0st9OtG3yTLhMoK6C0YOA+HGtswRXbP+iWmILn8quqJp9kbxtlRL87w9umW04zxHrca39Iw=
Subject: Re: [RFC-PATCH] fuse: shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1JQ60S-0005vO-QW@pomaz-ex.szeredi.hu>
References: <1203101902.15275.25.camel@brick>
	 <E1JQ60S-0005vO-QW@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 11:40:40 -0800
Message-Id: <1203104440.15275.27.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 20:13 +0100, Miklos Szeredi wrote:
> > 
> > fs/fuse/dir.c:909:7: warning: symbol 'err' shadows an earlier one
> > fs/fuse/dir.c:893:6: originally declared here
> > 
> > This means that an error between lines 909 and 923 will not be
> > returned.
> 
> Right.  Just submitted the exact same patch this morning :)
> 
> Thanks,
> Miklos
> 

Well, as long as someone did :)

Havey

