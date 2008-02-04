Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbYBDKBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbYBDKBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYBDKA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:00:59 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:43914 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750743AbYBDKA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:00:56 -0500
Date: Mon, 4 Feb 2008 18:59:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-sh <linux-sh@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] SH/Dreamcast - fix regressions, whitespace and memory leaks in Maple Bus driver
Message-ID: <20080204095958.GA28592@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1202068847.6262.7.camel@localhost.localdomain> <20080204011034.GA22021@linux-sh.org> <1202113424.6489.1.camel@localhost.localdomain> <20080204090203.GA28102@linux-sh.org> <49521.85.118.17.158.1202117711.squirrel@newgolddream.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49521.85.118.17.158.1202117711.squirrel@newgolddream.dyndns.info>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 09:35:11AM -0000, Adrian McMenamin wrote:
> On Mon, February 4, 2008 9:02 am, Paul Mundt wrote:
> > My previous commit was directly from _your_ patch, given that your
> > patches have a history of whitespace damage, this doesn't seem like much
> > of a stretch. It's true I neglected to run it through checkpatch, I'll be
> > more careful with that in the future when applying patches from certain
> > parties.
> >
> 
> I'm sorry. But that's garbage.
> 
http://lkml.org/lkml/2007/9/20/179

Also in my archives, and piped through checkpatch:

ERROR: use tabs not spaces
#118: FILE: drivers/sh/maple/maplebus.c:66:
+               return -EINVAL;$

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#123: FILE: drivers/sh/maple/maplebus.c:71:
+EXPORT_SYMBOL_GPL(maple_driver_register);

ERROR: use tabs not spaces
#144: FILE: drivers/sh/maple/maplebus.c:92:
+                           void (*callback) (struct mapleq * mq),$

ERROR: "foo * bar" should be "foo *bar"
#144: FILE: drivers/sh/maple/maplebus.c:92:
+                           void (*callback) (struct mapleq * mq),

ERROR: use tabs not spaces
#145: FILE: drivers/sh/maple/maplebus.c:93:
+                           unsigned long interval, unsigned long function)$

ERROR: use tabs not spaces
#162: FILE: drivers/sh/maple/maplebus.c:110:
+               kfree(dev->type->name);$

ERROR: use tabs not spaces
#163: FILE: drivers/sh/maple/maplebus.c:111:
+               kfree(dev->type);$

ERROR: use tabs not spaces
#185: FILE: drivers/sh/maple/maplebus.c:133:
+               return NULL;$

ERROR: use tabs not spaces
#191: FILE: drivers/sh/maple/maplebus.c:139:
+               kfree(mq);$

ERROR: use tabs not spaces
#192: FILE: drivers/sh/maple/maplebus.c:140:
+               return NULL;$

ERROR: use tabs not spaces
#204: FILE: drivers/sh/maple/maplebus.c:152:
+               return NULL;$

ERROR: use tabs not spaces
#211: FILE: drivers/sh/maple/maplebus.c:159:
+               kfree(dev);$

ERROR: use tabs not spaces
#212: FILE: drivers/sh/maple/maplebus.c:160:
+               return NULL;$

ERROR: use tabs not spaces
#221: FILE: drivers/sh/maple/maplebus.c:169:
+               return;$

ERROR: use tabs not spaces
#223: FILE: drivers/sh/maple/maplebus.c:171:
+               kmem_cache_free(maple_queue_cache, mdev->mq->recvbufdcsp);$

ERROR: use tabs not spaces
#224: FILE: drivers/sh/maple/maplebus.c:172:
+               kfree(mdev->mq);$

ERROR: use tabs not spaces
#249: FILE: drivers/sh/maple/maplebus.c:197:
+           mq->command | (to << 8) | (from << 16) | (len << 24);$

ERROR: use tabs not spaces
#252: FILE: drivers/sh/maple/maplebus.c:200:
+               *maple_sendptr++ = *lsendbuf++;$

ERROR: use tabs not spaces
#263: FILE: drivers/sh/maple/maplebus.c:211:
+               return;$

ERROR: use tabs not spaces
#265: FILE: drivers/sh/maple/maplebus.c:213:
+               return;$

ERROR: use tabs not spaces
#269: FILE: drivers/sh/maple/maplebus.c:217:
+               maple_build_block(mq);$

ERROR: use tabs not spaces
#270: FILE: drivers/sh/maple/maplebus.c:218:
+               list_move(&mq->list, &maple_sentq);$

ERROR: use tabs not spaces
#271: FILE: drivers/sh/maple/maplebus.c:219:
+               if (maple_packets++ > MAPLE_MAXPACKETS)$

ERROR: use tabs not spaces
#272: FILE: drivers/sh/maple/maplebus.c:220:
+                       break;$

ERROR: use tabs not spaces
#275: FILE: drivers/sh/maple/maplebus.c:223:
+               for (i = 0; i < (1 << MAPLE_DMA_PAGES); i++)$

ERROR: use tabs not spaces
#276: FILE: drivers/sh/maple/maplebus.c:224:
+                       dma_cache_sync(0, maple_sendbuf + i * PAGE_SIZE,$

ERROR: use tabs not spaces
#277: FILE: drivers/sh/maple/maplebus.c:225:
+                                      PAGE_SIZE, DMA_BIDIRECTIONAL);$

ERROR: use tabs not spaces
#282: FILE: drivers/sh/maple/maplebus.c:230:
+                                       void *devptr)$

ERROR: use tabs not spaces
#290: FILE: drivers/sh/maple/maplebus.c:238:
+               if (maple_drv->connect(mdev) == 0) {$

ERROR: use tabs not spaces
#291: FILE: drivers/sh/maple/maplebus.c:239:
+                       mdev->driver = maple_drv;$

ERROR: use tabs not spaces
#292: FILE: drivers/sh/maple/maplebus.c:240:
+                       return 1;$

ERROR: use tabs not spaces
#293: FILE: drivers/sh/maple/maplebus.c:241:
+               }$

ERROR: use tabs not spaces
#301: FILE: drivers/sh/maple/maplebus.c:249:
+               return;$

ERROR: use tabs not spaces
#303: FILE: drivers/sh/maple/maplebus.c:251:
+               if (mdev->driver->disconnect)$

ERROR: use tabs not spaces
#304: FILE: drivers/sh/maple/maplebus.c:252:
+                       mdev->driver->disconnect(mdev);$

ERROR: use tabs not spaces
#308: FILE: drivers/sh/maple/maplebus.c:256:
+               maple_release_device(&mdev->dev);$

ERROR: use tabs not spaces
#309: FILE: drivers/sh/maple/maplebus.c:257:
+               device_unregister(&mdev->dev);$

ERROR: use tabs not spaces
#332: FILE: drivers/sh/maple/maplebus.c:280:
+               if (*p == ' ')$

ERROR: use tabs not spaces
#333: FILE: drivers/sh/maple/maplebus.c:281:
+                       *p = '\0';$

ERROR: use tabs not spaces
#334: FILE: drivers/sh/maple/maplebus.c:282:
+               else$

ERROR: use tabs not spaces
#335: FILE: drivers/sh/maple/maplebus.c:283:
+                       break;$

ERROR: use tabs not spaces
#338: FILE: drivers/sh/maple/maplebus.c:286:
+               if (*p == ' ')$

ERROR: use tabs not spaces
#339: FILE: drivers/sh/maple/maplebus.c:287:
+                       *p = '\0';$

ERROR: use tabs not spaces
#340: FILE: drivers/sh/maple/maplebus.c:288:
+               else$

ERROR: use tabs not spaces
#341: FILE: drivers/sh/maple/maplebus.c:289:
+                       break;$

ERROR: use tabs not spaces
#346: FILE: drivers/sh/maple/maplebus.c:294:
+               /* Do this silently - as not a real device */$

ERROR: use tabs not spaces
#347: FILE: drivers/sh/maple/maplebus.c:295:
+               function = 0;$

ERROR: use tabs not spaces
#348: FILE: drivers/sh/maple/maplebus.c:296:
+               dev->driver = &maple_dummy_driver;$

ERROR: use tabs not spaces
#349: FILE: drivers/sh/maple/maplebus.c:297:
+               sprintf(dev->dev.bus_id, "%d:0.port", dev->port);$

ERROR: use tabs not spaces
#351: FILE: drivers/sh/maple/maplebus.c:299:
+               printk(KERN_INFO$

ERROR: use tabs not spaces
#352: FILE: drivers/sh/maple/maplebus.c:300:
+                      "Maple bus at (%d, %d): Connected function 0x%lX\n",$

ERROR: use tabs not spaces
#353: FILE: drivers/sh/maple/maplebus.c:301:
+                      dev->port, dev->unit, function);$

ERROR: use tabs not spaces
#355: FILE: drivers/sh/maple/maplebus.c:303:
+               matched =$

ERROR: use tabs not spaces
#356: FILE: drivers/sh/maple/maplebus.c:304:
+                   bus_for_each_drv(&maple_bus_type, NULL, dev,$

ERROR: use tabs not spaces
#357: FILE: drivers/sh/maple/maplebus.c:305:
+                                    attach_matching_maple_driver);$

ERROR: use tabs not spaces
#359: FILE: drivers/sh/maple/maplebus.c:307:
+               if (matched == 0) {$

ERROR: use tabs not spaces
#360: FILE: drivers/sh/maple/maplebus.c:308:
+                       /* Driver does not exist yet */$

ERROR: use tabs not spaces
#361: FILE: drivers/sh/maple/maplebus.c:309:
+                       printk(KERN_INFO$

ERROR: use tabs not spaces
#362: FILE: drivers/sh/maple/maplebus.c:310:
+                              "No maple driver found for this device\n");$

ERROR: use tabs not spaces
#363: FILE: drivers/sh/maple/maplebus.c:311:
+                       dev->driver = &maple_dummy_driver;$

ERROR: use tabs not spaces
#364: FILE: drivers/sh/maple/maplebus.c:312:
+               }$

ERROR: use tabs not spaces
#366: FILE: drivers/sh/maple/maplebus.c:314:
+               sprintf(dev->dev.bus_id, "%d:0%d.%lX", dev->port,$

ERROR: use tabs not spaces
#367: FILE: drivers/sh/maple/maplebus.c:315:
+                       dev->unit, function);$

ERROR: use tabs not spaces
#375: FILE: drivers/sh/maple/maplebus.c:323:
+               printk(KERN_INFO$

ERROR: use tabs not spaces
#376: FILE: drivers/sh/maple/maplebus.c:324:
+                      "Maple bus: Attempt to register device (%x, %x)$

ERROR: patch seems to be corrupt (line wrapped?)
#377: FILE: drivers/sh/maple/maplebus.c:324:
failed.\n",

ERROR: use tabs not spaces
#378: FILE: drivers/sh/maple/maplebus.c:325:
+                      dev->port, dev->unit);$

ERROR: use tabs not spaces
#379: FILE: drivers/sh/maple/maplebus.c:326:
+               maple_free_dev(dev);$

ERROR: use tabs not spaces
#396: FILE: drivers/sh/maple/maplebus.c:343:
+               return 1;$

ERROR: use tabs not spaces
#405: FILE: drivers/sh/maple/maplebus.c:352:
+           && time_after(jiffies, maple_dev->when)) {$

ERROR: use tabs not spaces
#406: FILE: drivers/sh/maple/maplebus.c:353:
+               maple_dev->when = jiffies + maple_dev->interval;$

ERROR: use tabs not spaces
#407: FILE: drivers/sh/maple/maplebus.c:354:
+               maple_dev->mq->command = MAPLE_COMMAND_GETCOND;$

ERROR: use tabs not spaces
#408: FILE: drivers/sh/maple/maplebus.c:355:
+               maple_dev->mq->sendbuf = &maple_dev->function;$

ERROR: use tabs not spaces
#409: FILE: drivers/sh/maple/maplebus.c:356:
+               maple_dev->mq->length = 1;$

ERROR: use tabs not spaces
#410: FILE: drivers/sh/maple/maplebus.c:357:
+               maple_add_packet(maple_dev->mq);$

ERROR: use tabs not spaces
#411: FILE: drivers/sh/maple/maplebus.c:358:
+               liststatus++;$

ERROR: use tabs not spaces
#413: FILE: drivers/sh/maple/maplebus.c:360:
+               if (time_after(jiffies, maple_pnp_time)) {$

ERROR: use tabs not spaces
#414: FILE: drivers/sh/maple/maplebus.c:361:
+                       maple_dev->mq->command = MAPLE_COMMAND_DEVINFO;$

ERROR: use tabs not spaces
#415: FILE: drivers/sh/maple/maplebus.c:362:
+                       maple_dev->mq->length = 0;$

ERROR: use tabs not spaces
#416: FILE: drivers/sh/maple/maplebus.c:363:
+                       maple_add_packet(maple_dev->mq);$

ERROR: use tabs not spaces
#417: FILE: drivers/sh/maple/maplebus.c:364:
+                       liststatus++;$

ERROR: use tabs not spaces
#418: FILE: drivers/sh/maple/maplebus.c:365:
+               }$

ERROR: use tabs not spaces
#428: FILE: drivers/sh/maple/maplebus.c:375:
+               return;$

ERROR: use tabs not spaces
#430: FILE: drivers/sh/maple/maplebus.c:377:
+               return;$

ERROR: use tabs not spaces
#434: FILE: drivers/sh/maple/maplebus.c:381:
+                        setup_maple_commands);$

ERROR: use tabs not spaces
#436: FILE: drivers/sh/maple/maplebus.c:383:
+               maple_pnp_time = jiffies + MAPLE_PNP_INTERVAL;$

ERROR: use tabs not spaces
#438: FILE: drivers/sh/maple/maplebus.c:385:
+               INIT_LIST_HEAD(&maple_sentq);$

ERROR: use tabs not spaces
#439: FILE: drivers/sh/maple/maplebus.c:386:
+               maple_send();$

ERROR: use tabs not spaces
#452: FILE: drivers/sh/maple/maplebus.c:399:
+               ds.port = mdev->port;$

ERROR: use tabs not spaces
#453: FILE: drivers/sh/maple/maplebus.c:400:
+               ds.unit = k + 1;$

ERROR: use tabs not spaces
#454: FILE: drivers/sh/maple/maplebus.c:401:
+               retval =$

ERROR: use tabs not spaces
#455: FILE: drivers/sh/maple/maplebus.c:402:
+                   bus_for_each_dev(&maple_bus_type, NULL, &ds,$

ERROR: use tabs not spaces
#456: FILE: drivers/sh/maple/maplebus.c:403:
+                                    detach_maple_device);$

ERROR: use tabs not spaces
#457: FILE: drivers/sh/maple/maplebus.c:404:
+               if (retval) {$

ERROR: use tabs not spaces
#458: FILE: drivers/sh/maple/maplebus.c:405:
+                       submask = submask >> 1;$

ERROR: use tabs not spaces
#459: FILE: drivers/sh/maple/maplebus.c:406:
+                       continue;$

ERROR: use tabs not spaces
#460: FILE: drivers/sh/maple/maplebus.c:407:
+               }$

ERROR: use tabs not spaces
#461: FILE: drivers/sh/maple/maplebus.c:408:
+               devcheck = submask & 0x01;$

ERROR: use tabs not spaces
#462: FILE: drivers/sh/maple/maplebus.c:409:
+               if (devcheck) {$

ERROR: use tabs not spaces
#463: FILE: drivers/sh/maple/maplebus.c:410:
+                       mdev_add = maple_alloc_dev(mdev->port, k + 1);$

ERROR: use tabs not spaces
#464: FILE: drivers/sh/maple/maplebus.c:411:
+                       if (!mdev_add)$

ERROR: use tabs not spaces
#465: FILE: drivers/sh/maple/maplebus.c:412:
+                               return;$

ERROR: use tabs not spaces
#466: FILE: drivers/sh/maple/maplebus.c:413:
+                       mdev_add->mq->command = MAPLE_COMMAND_DEVINFO;$

ERROR: use tabs not spaces
#467: FILE: drivers/sh/maple/maplebus.c:414:
+                       mdev_add->mq->length = 0;$

ERROR: use tabs not spaces
#468: FILE: drivers/sh/maple/maplebus.c:415:
+                       maple_add_packet(mdev_add->mq);$

ERROR: use tabs not spaces
#469: FILE: drivers/sh/maple/maplebus.c:416:
+                       scanning = 1;$

ERROR: use tabs not spaces
#470: FILE: drivers/sh/maple/maplebus.c:417:
+               }$

ERROR: use tabs not spaces
#471: FILE: drivers/sh/maple/maplebus.c:418:
+               submask = submask >> 1;$

ERROR: use tabs not spaces
#488: FILE: drivers/sh/maple/maplebus.c:435:
+                               struct mapleq *mq)$

ERROR: use tabs not spaces
#491: FILE: drivers/sh/maple/maplebus.c:438:
+               list_del(&mq->list);$

ERROR: use tabs not spaces
#492: FILE: drivers/sh/maple/maplebus.c:439:
+               maple_clean_submap(mdev);$

ERROR: use tabs not spaces
#493: FILE: drivers/sh/maple/maplebus.c:440:
+               printk(KERN_INFO$

ERROR: use tabs not spaces
#494: FILE: drivers/sh/maple/maplebus.c:441:
+                      "Maple bus device detaching at (%d, %d)\n",$

ERROR: use tabs not spaces
#495: FILE: drivers/sh/maple/maplebus.c:442:
+                      mdev->port, mdev->unit);$

ERROR: use tabs not spaces
#496: FILE: drivers/sh/maple/maplebus.c:443:
+               maple_detach_driver(mdev);$

ERROR: use tabs not spaces
#497: FILE: drivers/sh/maple/maplebus.c:444:
+               return;$

ERROR: use tabs not spaces
#500: FILE: drivers/sh/maple/maplebus.c:447:
+               printk(KERN_INFO "No maple devices attached to port %d\n",$

ERROR: use tabs not spaces
#501: FILE: drivers/sh/maple/maplebus.c:448:
+                      mdev->port);$

ERROR: use tabs not spaces
#502: FILE: drivers/sh/maple/maplebus.c:449:
+               return;$

ERROR: use tabs not spaces
#509: FILE: drivers/sh/maple/maplebus.c:456:
+                                  char *recvbuf)$

ERROR: use tabs not spaces
#513: FILE: drivers/sh/maple/maplebus.c:460:
+               maple_attach_driver(mdev);$

ERROR: use tabs not spaces
#514: FILE: drivers/sh/maple/maplebus.c:461:
+               return;$

ERROR: use tabs not spaces
#517: FILE: drivers/sh/maple/maplebus.c:464:
+               submask = recvbuf[2] & 0x1F;$

ERROR: use tabs not spaces
#518: FILE: drivers/sh/maple/maplebus.c:465:
+               if (submask ^ subdevice_map[mdev->port]) {$

ERROR: use tabs not spaces
#519: FILE: drivers/sh/maple/maplebus.c:466:
+                       maple_map_subunits(mdev, submask);$

ERROR: use tabs not spaces
#520: FILE: drivers/sh/maple/maplebus.c:467:
+                       subdevice_map[mdev->port] = submask;$

ERROR: use tabs not spaces
#521: FILE: drivers/sh/maple/maplebus.c:468:
+               }$

ERROR: use tabs not spaces
#534: FILE: drivers/sh/maple/maplebus.c:481:
+               return;$

ERROR: use tabs not spaces
#537: FILE: drivers/sh/maple/maplebus.c:484:
+               list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {$

ERROR: use tabs not spaces
#538: FILE: drivers/sh/maple/maplebus.c:485:
+                       recvbuf = mq->recvbuf;$

ERROR: use tabs not spaces
#539: FILE: drivers/sh/maple/maplebus.c:486:
+                       code = recvbuf[0];$

ERROR: use tabs not spaces
#540: FILE: drivers/sh/maple/maplebus.c:487:
+                       dev = mq->dev;$

ERROR: use tabs not spaces
#541: FILE: drivers/sh/maple/maplebus.c:488:
+                       switch (code) {$

ERROR: use tabs not spaces
#542: FILE: drivers/sh/maple/maplebus.c:489:
+                       case MAPLE_RESPONSE_NONE:$

ERROR: use tabs not spaces
#543: FILE: drivers/sh/maple/maplebus.c:490:
+                               maple_response_none(dev, mq);$

ERROR: use tabs not spaces
#544: FILE: drivers/sh/maple/maplebus.c:491:
+                               break;$

ERROR: use tabs not spaces
#546: FILE: drivers/sh/maple/maplebus.c:493:
+                       case MAPLE_RESPONSE_DEVINFO:$

ERROR: use tabs not spaces
#547: FILE: drivers/sh/maple/maplebus.c:494:
+                               maple_response_devinfo(dev, recvbuf);$

ERROR: use tabs not spaces
#548: FILE: drivers/sh/maple/maplebus.c:495:
+                               break;$

ERROR: use tabs not spaces
#550: FILE: drivers/sh/maple/maplebus.c:497:
+                       case MAPLE_RESPONSE_DATATRF:$

ERROR: use tabs not spaces
#551: FILE: drivers/sh/maple/maplebus.c:498:
+                               if (dev->callback)$

ERROR: use tabs not spaces
#552: FILE: drivers/sh/maple/maplebus.c:499:
+                                       dev->callback(mq);$

ERROR: use tabs not spaces
#553: FILE: drivers/sh/maple/maplebus.c:500:
+                               break;$

ERROR: use tabs not spaces
#555: FILE: drivers/sh/maple/maplebus.c:502:
+                       case MAPLE_RESPONSE_FILEERR:$

ERROR: use tabs not spaces
#556: FILE: drivers/sh/maple/maplebus.c:503:
+                       case MAPLE_RESPONSE_AGAIN:$

ERROR: use tabs not spaces
#557: FILE: drivers/sh/maple/maplebus.c:504:
+                       case MAPLE_RESPONSE_BADCMD:$

ERROR: use tabs not spaces
#558: FILE: drivers/sh/maple/maplebus.c:505:
+                       case MAPLE_RESPONSE_BADFUNC:$

ERROR: use tabs not spaces
#559: FILE: drivers/sh/maple/maplebus.c:506:
+                               printk(KERN_DEBUG$

ERROR: use tabs not spaces
#560: FILE: drivers/sh/maple/maplebus.c:507:
+                                      "Maple non-fatal error 0x%X\n",$

ERROR: use tabs not spaces
#561: FILE: drivers/sh/maple/maplebus.c:508:
+                                      code);$

ERROR: use tabs not spaces
#562: FILE: drivers/sh/maple/maplebus.c:509:
+                               break;$

ERROR: use tabs not spaces
#564: FILE: drivers/sh/maple/maplebus.c:511:
+                       case MAPLE_RESPONSE_ALLINFO:$

ERROR: use tabs not spaces
#565: FILE: drivers/sh/maple/maplebus.c:512:
+                               printk(KERN_DEBUG$

ERROR: use tabs not spaces
#566: FILE: drivers/sh/maple/maplebus.c:513:
+                                      "Maple - extended device$

ERROR: use tabs not spaces
#568: FILE: drivers/sh/maple/maplebus.c:514:
+                               break;$

ERROR: use tabs not spaces
#570: FILE: drivers/sh/maple/maplebus.c:516:
+                       case MAPLE_RESPONSE_OK:$

ERROR: use tabs not spaces
#571: FILE: drivers/sh/maple/maplebus.c:517:
+                               break;$

ERROR: use tabs not spaces
#573: FILE: drivers/sh/maple/maplebus.c:519:
+                       default:$

ERROR: use tabs not spaces
#574: FILE: drivers/sh/maple/maplebus.c:520:
+                               break;$

ERROR: use tabs not spaces
#575: FILE: drivers/sh/maple/maplebus.c:521:
+                       }$

ERROR: use tabs not spaces
#576: FILE: drivers/sh/maple/maplebus.c:522:
+               }$

ERROR: use tabs not spaces
#577: FILE: drivers/sh/maple/maplebus.c:523:
+               INIT_LIST_HEAD(&maple_sentq);$

ERROR: use tabs not spaces
#578: FILE: drivers/sh/maple/maplebus.c:524:
+               if (scanning == 1) {$

ERROR: use tabs not spaces
#579: FILE: drivers/sh/maple/maplebus.c:525:
+                       maple_send();$

ERROR: use tabs not spaces
#580: FILE: drivers/sh/maple/maplebus.c:526:
+                       scanning = 2;$

ERROR: use tabs not spaces
#581: FILE: drivers/sh/maple/maplebus.c:527:
+               } else$

ERROR: use tabs not spaces
#582: FILE: drivers/sh/maple/maplebus.c:528:
+                       scanning = 0;$

ERROR: use tabs not spaces
#584: FILE: drivers/sh/maple/maplebus.c:530:
+               if (started == 0)$

ERROR: use tabs not spaces
#585: FILE: drivers/sh/maple/maplebus.c:531:
+                       started = 1;$

ERROR: use tabs not spaces
#628: FILE: drivers/sh/maple/maplebus.c:574:
+           (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,$

ERROR: use tabs not spaces
#629: FILE: drivers/sh/maple/maplebus.c:575:
+                                     MAPLE_DMA_PAGES);$

ERROR: use tabs not spaces
#631: FILE: drivers/sh/maple/maplebus.c:577:
+               return -ENOMEM;$

ERROR: use tabs not spaces
#636: FILE: drivers/sh/maple/maplebus.c:582:
+                                 struct device_driver *drvptr)$

ERROR: use tabs not spaces
#645: FILE: drivers/sh/maple/maplebus.c:591:
+               return 0;$

ERROR: use tabs not spaces
#647: FILE: drivers/sh/maple/maplebus.c:593:
+                be32_to_cpu(maple_drv->function))$

ERROR: use tabs not spaces
#648: FILE: drivers/sh/maple/maplebus.c:594:
+               return 1;$

ERROR: use tabs not spaces
#653: FILE: drivers/sh/maple/maplebus.c:599:
+                           int num_envp, char *buffer, int buffer_size)$

ERROR: use tabs not spaces
#664: FILE: drivers/sh/maple/maplebus.c:610:
+               .name = "maple_dummy_driver",$

ERROR: use tabs not spaces
#665: FILE: drivers/sh/maple/maplebus.c:611:
+               .bus =  &maple_bus_type,$

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#675: FILE: drivers/sh/maple/maplebus.c:621:
+EXPORT_SYMBOL_GPL(maple_bus_type);

ERROR: use tabs not spaces
#690: FILE: drivers/sh/maple/maplebus.c:636:
+               goto cleanup;$

ERROR: use tabs not spaces
#694: FILE: drivers/sh/maple/maplebus.c:640:
+               goto cleanup_device;$

ERROR: use tabs not spaces
#699: FILE: drivers/sh/maple/maplebus.c:645:
+               goto cleanup_bus;$

ERROR: use tabs not spaces
#704: FILE: drivers/sh/maple/maplebus.c:650:
+               printk(KERN_INFO$

ERROR: use tabs not spaces
#705: FILE: drivers/sh/maple/maplebus.c:651:
+                      "Maple bus: Failed to allocate Maple DMA buffers\n");$

ERROR: use tabs not spaces
#706: FILE: drivers/sh/maple/maplebus.c:652:
+               goto cleanup_basic;$

ERROR: use tabs not spaces
#712: FILE: drivers/sh/maple/maplebus.c:658:
+               printk(KERN_INFO$

ERROR: use tabs not spaces
#713: FILE: drivers/sh/maple/maplebus.c:659:
+                      "Maple bus: Failed to grab maple DMA IRQ\n");$

ERROR: use tabs not spaces
#714: FILE: drivers/sh/maple/maplebus.c:660:
+               goto cleanup_dma;$

ERROR: use tabs not spaces
#720: FILE: drivers/sh/maple/maplebus.c:666:
+               printk(KERN_INFO "Maple bus: Failed to grab VBLANK IRQ\n");$

ERROR: use tabs not spaces
#721: FILE: drivers/sh/maple/maplebus.c:667:
+               goto cleanup_irq;$

ERROR: use tabs not spaces
#725: FILE: drivers/sh/maple/maplebus.c:671:
+           kmem_cache_create("maple_queue_cache", 0x400, 0,$

ERROR: use tabs not spaces
#726: FILE: drivers/sh/maple/maplebus.c:672:
+                             SLAB_HWCACHE_ALIGN, NULL);$

ERROR: use tabs not spaces
#729: FILE: drivers/sh/maple/maplebus.c:675:
+               goto cleanup_bothirqs;$

ERROR: use tabs not spaces
#733: FILE: drivers/sh/maple/maplebus.c:679:
+               mdev[i] = maple_alloc_dev(i, 0);$

ERROR: use tabs not spaces
#734: FILE: drivers/sh/maple/maplebus.c:680:
+               if (!mdev[i]) {$

ERROR: use tabs not spaces
#735: FILE: drivers/sh/maple/maplebus.c:681:
+                       while (i-- > 0)$

ERROR: use tabs not spaces
#736: FILE: drivers/sh/maple/maplebus.c:682:
+                               maple_free_dev(mdev[i]);$

ERROR: use tabs not spaces
#737: FILE: drivers/sh/maple/maplebus.c:683:
+                       goto cleanup_cache;$

ERROR: use tabs not spaces
#738: FILE: drivers/sh/maple/maplebus.c:684:
+               }$

ERROR: use tabs not spaces
#739: FILE: drivers/sh/maple/maplebus.c:685:
+               mdev[i]->registered = 0;$

ERROR: use tabs not spaces
#740: FILE: drivers/sh/maple/maplebus.c:686:
+               mdev[i]->mq->command = MAPLE_COMMAND_DEVINFO;$

ERROR: use tabs not spaces
#741: FILE: drivers/sh/maple/maplebus.c:687:
+               mdev[i]->mq->length = 0;$

ERROR: use tabs not spaces
#742: FILE: drivers/sh/maple/maplebus.c:688:
+               maple_attach_driver(mdev[i]);$

ERROR: use tabs not spaces
#743: FILE: drivers/sh/maple/maplebus.c:689:
+               maple_add_packet(mdev[i]->mq);$

ERROR: use tabs not spaces
#744: FILE: drivers/sh/maple/maplebus.c:690:
+               subdevice_map[i] = 0;$

ERROR: Missing Signed-off-by: line(s)

total: 205 errors, 2 warnings, 758 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Thanks for playing, try again.
