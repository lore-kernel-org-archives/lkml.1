Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYJ3BTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYJ3BTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYJ3BTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:19:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:36072 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYJ3BTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WGmajh/zSpiafDJN0o5XIg8D06MUI8kNyk6kMsBVkp8vZE+jJMPk5l5AetAnnDd34j
         Xh2HlOK8AxYK7Sj2t5CdNw37Kgcu4mI0A45HbX1iWIo1ih+iJ431gk8wW+ct/4WyMjmx
         2HZMbphOCFm/8V01qTeVaM12DoUdyVhDFaZGA=
Message-ID: <b6c5339f0810291819ld7d6043k56b11128bc6252cb@mail.gmail.com>
Date: Wed, 29 Oct 2008 21:19:01 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-2.6 2008-10-29
Cc: "Arjan van de Ven" <arjan@infradead.org>, davem@davemloft.net,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mcgrof@gmail.com, mickflemm@gmail.com
In-Reply-To: <20081029233350.GE3485@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081029231855.GD3485@tuxdriver.com>
	 <20081029162324.28f5864d@infradead.org>
	 <20081029233350.GE3485@tuxdriver.com>
X-Google-Sender-Auth: c39e2a1896cfcd2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 7:33 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Oct 29, 2008 at 04:23:24PM -0700, Arjan van de Ven wrote:
>> On Wed, 29 Oct 2008 19:18:55 -0400
>> "John W. Linville" <linville@tuxdriver.com> wrote:
>> it seems to have added a few WARN_ON()s which now end up at the top of
>> the list .. are these known or should I spend some time writing reports
>> for netdev ?

Pavel Roskin posted one such WARN_ON to ath5k-devel a few days ago.
Seems related to setup of the rate tables, but I haven't reproduced it
here yet.  I'll see if he has more info...

-- 
Bob Copeland %% www.bobcopeland.com
