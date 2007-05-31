Return-Path: <linux-kernel-owner+w=401wt.eu-S1760403AbXEaLFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403AbXEaLFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 07:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbXEaLE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 07:04:56 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:26745 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbXEaLEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 07:04:55 -0400
Message-ID: <465EABD2.9090102@de.ibm.com>
Date: Thu, 31 May 2007 13:04:50 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070521)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, hugh@veritas.com, neilb@suse.de,
       zanussi@us.ibm.com, Linus Torvalds <torvalds@osdl.org>,
       hch@infradead.org
Subject: Re: [PATCH] sendfile removal
References: <20070531103316.GO32105@kernel.dk>
In-Reply-To: <20070531103316.GO32105@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Work to be done:
> 
> - The ext2 xip support needs a splice_read() implementation, currently I
>   just if 0'ed out the send xip_file_sendfile(). CC'ed Carsten, who
>   seems to be the author of this code.
Yup. Will do the splice_read implementation for xip. Do you want to 
see it in splice.c or should it go to filemap_xip?

Acked-by: Carsten Otte <cotte@de.ibm.com>
