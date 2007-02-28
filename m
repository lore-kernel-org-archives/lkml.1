Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXB1VJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXB1VJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXB1VJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:09:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbXB1VJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:09:37 -0500
Message-ID: <45E5EF89.4050707@redhat.com>
Date: Wed, 28 Feb 2007 16:09:29 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 01/22] update ctime and mtime for mmaped write
References: <20070227231442.627972152@szeredi.hu> <20070227231544.519463073@szeredi.hu> <45E58EB8.6030502@redhat.com> <E1HMSGE-000886-00@dorka.pomaz.szeredi.hu> <45E5BA2E.8060003@redhat.com> <E1HMSy2-0008F6-00@dorka.pomaz.szeredi.hu> <45E5DF8E.80109@redhat.com> <E1HMVWJ-00009K-00@dorka.pomaz.szeredi.hu> <E1HMVt0-0000D2-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1HMVt0-0000D2-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> What happens if the application overwrites what it had written some
>> time later?  Nothing.  The page is already read-write, the pte dirty,
>> so even though the file was clearly modified, there's absolutely no
>> way in which this can be used to force an update to the timestamp.
>>     
>
> Which, I realize now, actually means, that the patch is wrong.  Msync
> will have to write protect the page table entries, so that later
> dirtyings may have an effect on the timestamp.

I thought that PeterZ's changes were to write-protect the page after
cleaning it so that future modifications could be detected and tracked
accordingly?  Does the right thing not happen already?

    Thanx...

       ps
