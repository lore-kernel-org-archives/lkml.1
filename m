Return-Path: <linux-kernel-owner+w=401wt.eu-S966314AbXDDFm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966314AbXDDFm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966316AbXDDFmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:42:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:23942 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966314AbXDDFmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L7iLbwySSgNw4Id1OMakDSzPAt7LaEaxDotGFFRyZKa/pWFeTQH9/SGt8EWAAw1gZDuat/YPy8QtQfNluCe2Tko/T1KAn7yG9uJwH0GRGvDQsJfL7AQbNPr4vzovusaBA94g/CgepD7wIXxDqpOK6R7obrFqnRBwAmAEUCzNyJI=
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Martin Mares <mj@ucw.cz>
Cc: Paul LeoNerd Evans <leonerd@leonerd.org.uk>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <mj+md-20070403.153720.5293.nikam@ucw.cz>
References: <46110F88.5040905@gmail.com>
	 <mj+md-20070403.114037.27180.nikam@ucw.cz> <20070403145151.GN26707@cel.leo>
	 <mj+md-20070403.153720.5293.nikam@ucw.cz>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 13:42:44 +0800
Message-Id: <1175665364.4519.10.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 17:37 +0200, Martin Mares wrote:
> Hello!
> 
> > Does whatever defines what these escapes mean, have any comment to make
> > about UTF-8? If not, why can't we declare that UTF-8 mode is the "reset"
> > mode, the default that would be dropped to on a full reset, and if
> > anyone wanted to switch that out to non-default not-UTF-8 mode, they
> > could, but that a reset will always reenable it again..?
> 
> Maybe it would be a little bit more convenient, but I doubt that such
> bit of convenience justifies breaking backward compatibility.

Please note that I have dropped this patch in favor of this one:

http://lkml.org/lkml/2007/4/2/422

This patch behaves exactly as the one Paul posted before.

Tony


