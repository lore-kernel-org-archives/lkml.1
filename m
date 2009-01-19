Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZASSMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZASSMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZASSMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:12:46 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:49996 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZASSMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:12:45 -0500
Message-ID: <4974C288.7030301@oracle.com>
Date: Mon, 19 Jan 2009 10:12:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       zbr@ioremap.net, Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for January 19 (DST)
References: <20090119172732.e772d8ea.sfr@canb.auug.org.au>
In-Reply-To: <20090119172732.e772d8ea.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4974C28B.01FB:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> There will be no build results for today's linux-next as our build server
> has failed.
> 
> Changes since 20090116:


DST build fails when CONFIG_BLOCK=n:

In file included from /local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:22:
/local/linsrc/linux-next-20090119/include/linux/dst.h: In function 'dst_bio_to_cmd':
/local/linsrc/linux-next-20090119/include/linux/dst.h:520: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/include/linux/dst.h:520: error: 'BIO_POOL_BITS' undeclared (first use in this function)
/local/linsrc/linux-next-20090119/include/linux/dst.h:520: error: (Each undeclared identifier is reported only once
/local/linsrc/linux-next-20090119/include/linux/dst.h:520: error: for each function it appears in.)
/local/linsrc/linux-next-20090119/include/linux/dst.h:521: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/include/linux/dst.h:522: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/include/linux/dst.h:525: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: In function 'dst_node_set_size':
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:86: error: implicit declaration of function 'set_capacity'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:88: error: implicit declaration of function 'bdget_disk'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:88: warning: assignment makes pointer from integer without a cast
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:93: error: implicit declaration of function 'bdput'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: In function 'dst_request':
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:102: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:104: error: implicit declaration of function 'bio_get'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: In function 'dst_bdev_open':
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:114: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: In function 'dst_bdev_release':
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:122: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: At top level:
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:128: error: variable 'dst_blk_ops' has initializer but incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:129: error: unknown field 'open' specified in initializer
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:129: warning: excess elements in struct initializer
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:129: warning: (near initialization for 'dst_blk_ops')
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:130: error: unknown field 'release' specified in initializer
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:130: warning: excess elements in struct initializer
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:130: warning: (near initialization for 'dst_blk_ops')
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:131: error: unknown field 'owner' specified in initializer
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:131: warning: excess elements in struct initializer
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:131: warning: (near initialization for 'dst_blk_ops')
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: In function 'dst_node_create_disk':
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:143: error: implicit declaration of function 'blk_init_queue'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:143: warning: assignment makes pointer from integer without a cast
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:147: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:148: error: implicit declaration of function 'blk_queue_make_request'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:149: error: implicit declaration of function 'blk_queue_max_phys_segments'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:150: error: implicit declaration of function 'blk_queue_max_hw_segments'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:153: error: implicit declaration of function 'alloc_disk'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:153: warning: assignment makes pointer from integer without a cast
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:159: error: implicit declaration of function 'set_disk_ro'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:171: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:172: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:173: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:174: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:175: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:176: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:176: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:181: error: implicit declaration of function 'put_disk'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:183: error: implicit declaration of function 'blk_cleanup_queue'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: In function 'dst_node_cleanup':
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:372: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:380: error: implicit declaration of function 'blkdev_put'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: In function 'dst_setup_export':
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:488: error: implicit declaration of function 'open_by_devnum'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:488: warning: assignment makes pointer from integer without a cast
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: In function 'dst_start_remote':
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:618: error: implicit declaration of function 'add_disk'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:620: error: dereferencing pointer to incomplete type
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: In function 'dst_node_remove_unload':
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:696: error: implicit declaration of function 'del_gendisk'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c: In function 'dst_sys_init':
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:928: error: implicit declaration of function 'register_blkdev'
/local/linsrc/linux-next-20090119/drivers/staging/dst/dcore.c:949: error: implicit declaration of function 'unregister_blkdev'


-- 
~Randy
