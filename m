Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXLDGpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXLDGpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 01:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbXLDGpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 01:45:13 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:27936 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbXLDGpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 01:45:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=MoYaVjdqXgglVdSXgnSoBUxVSXZJKPvw3MMBQjfMHxsLcJSbFtNObG29lp07uvVHaZK4XuqwedT6Kwv5geV/MXLAcRy48v1DL5+/sgu3BRC8GCMR3AeqZWfqtqSwezp+/S3k6DQcC1iq5r0AFRbjZQSPesifsC1b+9Ya6D8Ix+s=
Date: Tue, 4 Dec 2007 14:45:47 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: The use of KOBJ_NAME_LEN
Message-ID: <20071204064547.GA17094@darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Does the KOBJ_NAME_LEN really means the limit of kobject name length? seems not . And if it's true, is the KOBJ_NAME_LEN of 20 enough to use?

In the kobject_set_name, the limit is 1024. Looks like either the comment or the code should be updated.

/**
 *      kobject_set_name - Set the name of an object
 *      @kobj:  object.
 *      @fmt:   format string used to build the name
 *
 *      If strlen(name) >= KOBJ_NAME_LEN, then use a dynamically allocated
 *      string that @kobj->k_name points to. Otherwise, use the static 
 *      @kobj->name array.
 */

Regards
dave
