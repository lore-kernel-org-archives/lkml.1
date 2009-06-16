Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbZFPTkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbZFPTkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbZFPTkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:40:45 -0400
Received: from www84.your-server.de ([213.133.104.84]:48767 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbZFPTkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:40:45 -0400
Subject: Re: [RFC] set the thread name
From: Stefani Seibold <stefani@seibold.net>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <36ca99e90906161214u6624014q3f3dc4e234bdf772@mail.gmail.com>
References: <1245177592.14543.1.camel@wall-e>
	 <36ca99e90906161214u6624014q3f3dc4e234bdf772@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 21:40:27 +0200
Message-Id: <1245181227.16466.3.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 16.06.2009, 21:14 +0200 schrieb Bert Wesarg:
> Hi,
> 
> On Tue, Jun 16, 2009 at 20:39, Stefani Seibold<stefani@seibold.net> wrote:
> > Currently it is not easy to identify a thread in linux, because there is
> > no thread name like in some other OS.
> >
> > If there were are thread name then we could extend a kernel segv message
> > and the /proc/<pid>/task/<tid>/... entries by a TName value like this:
> prctl(PR_SET_NAME, ...) works perfectly here.
> 
Ooops... I did not noticed that this is already implemented. Thats works
perfectly ;-)



